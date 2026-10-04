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
  };

  outputs =
    inputs@{ nixpkgs, ... }:
    let
      settings = import ./settings.nix;
    in
    {
      nixosConfigurations.beryllium = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs settings; };
        modules = [ ./hosts/beryllium ];
      };

      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-tree;
    };
}
