{
  description = "NixOS on a Xiaomi POCO F1 (beryllium) with vanilla-mobile-nixos";

  inputs = {
    vanilla-mobile-nixos.url = "github:vanilla-mobile-nixos/vanilla-mobile-nixos";

    # Use the nixpkgs revision vanilla-mobile-nixos is built and cached against.
    nixpkgs.follows = "vanilla-mobile-nixos/nixpkgs";

    # Use disko fork until this PR is merged:
    # <https://github.com/nix-community/disko/pull/1008>
    disko = {
      url = "github:JuneStepp/disko/mobile";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Valve's native aarch64 Steam client. The fork removes the Vulkan ICD
    # filter in guest-run.sh so the real Adreno GPU (Turnip) is detected.
    steam-arm64-nix = {
      url = "github:sinavarasina/steam-arm64-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, ... }:
    let
      forAllSystems =
        f:
        nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (
          system: f nixpkgs.legacyPackages.${system}
        );
    in
    {
      nixosConfigurations.beryllium = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./settings.nix
          ./hosts/beryllium
        ];
      };

      formatter = forAllSystems (pkgs: pkgs.nixfmt-tree);

      # `nix flake check` also evaluates nixosConfigurations.beryllium, which is
      # what catches a bad option value (e.g. an unknown displayPanel) without
      # an aarch64 builder.
      checks = forAllSystems (pkgs: {
        formatting = pkgs.runCommand "check-formatting" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
          find ${self} -name '*.nix' -exec nixfmt --check {} +
          touch $out
        '';
      });
    };
}
