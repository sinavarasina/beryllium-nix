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
    # filter in guest-run.sh so Turnip is detected, and adds Deck-mode helpers.
    steam-arm64-nix = {
      url = "github:sinavarasina/steam-arm64-nix/deck-mode";
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
      beryllium = self.nixosConfigurations.beryllium.config;
    in
    {
      nixosConfigurations.beryllium = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./settings.nix
          ./hosts/beryllium
        ];
      };

      # Short names for the two things the flash needs, so the commands in the
      # README stay short. `images-script` sets `buildSystem` to the host
      # running `nix build`, so on an x86_64 PC the disko VM runs natively.
      packages = forAllSystems (pkgs: {
        images-script =
          (self.nixosConfigurations.beryllium.extendModules {
            modules = [
              { vanilla-mobile.installer.buildSystem = pkgs.stdenv.hostPlatform.system; }
            ];
          }).config.system.build.diskoImagesScript;
        uboot = beryllium.vanilla-mobile.deviceInfo.uboot;
      });

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
