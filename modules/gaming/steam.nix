# Valve's native aarch64 Steam client and the FEX pieces x86 games need.
{ inputs, ... }:
{
  imports = [ inputs.steam-arm64-nix.nixosModules.fex-host ];

  nixpkgs.overlays = [ inputs.steam-arm64-nix.overlays.default ];
  nixpkgs.config.allowUnfree = true;

  programs.steam-arm64.fexHost.enable = true;

  # Valve's binaries ask for /lib/ld-linux-aarch64.so.1.
  programs.nix-ld.enable = true;
}
