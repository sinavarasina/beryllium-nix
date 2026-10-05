# MangoHud from upstream master instead of the last release (v0.8.4).
#
# Master carries the msm (Adreno) GPU metrics fixes (MangoHud#2073, #2085) that
# no release has shipped yet. The revision is pinned by flake.lock; bump it with
#   nix flake update mangohud-src
# Set `beryllium.gaming.mangohud.useMaster = false` to return to nixpkgs' release.
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  options.beryllium.gaming.mangohud.useMaster = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = "Build MangoHud from the mangohud-src flake input.";
  };

  config = {
    nixpkgs.overlays = lib.mkIf config.beryllium.gaming.mangohud.useMaster [
      (final: prev: {
        mangohud = prev.mangohud.overrideAttrs {
          version = "0.8.4-unstable-${builtins.substring 0 8 inputs.mangohud-src.lastModifiedDate}";
          src = inputs.mangohud-src;
        };
      })
    ];

    environment.systemPackages = [ pkgs.mangohud ];

    environment.etc."mangohud/MangoHud.conf".source = ./MangoHud.conf;
  };
}
