{
  inputs,
  lib,
  pkgs,
  settings,
  ...
}:
let
  steam = pkgs.steam-arm64.override { useMuvm = false; };
  session = pkgs.writeShellScript "steam-session" ''
    set -eu
    export PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.gnused
        pkgs.gamescope
      ]
    }:$PATH
    exec > "$HOME/steam-session.log" 2>&1

    export STEAM_ARM64_ROOT="$HOME/.local/share/Steam"

    exec gamescope -e --prefer-output DSI-1 --force-orientation left -- \
      ${steam}/bin/steam-arm64 -gamepadui
  '';
in
{
  imports = [ inputs.steam-arm64-nix.nixosModules.fex-host ];

  nixpkgs.overlays = [ inputs.steam-arm64-nix.overlays.default ];
  nixpkgs.config.allowUnfree = true;

  programs.steam-arm64.fexHost.enable = true;

  programs.nix-ld.enable = true;
  hardware.graphics.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
  environment.systemPackages = [ pkgs.mangohud ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.JustWorksRepairing = "always";
  };

  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "${session}";
        user = settings.user;
      };
      default_session = initial_session;
    };
  };
}
