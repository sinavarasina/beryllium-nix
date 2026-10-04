{
  inputs,
  lib,
  pkgs,
  settings,
  ...
}:
let
  launcher = "${pkgs.steam-arm64}/bin/steam-arm64";

  # gamescope kiosk running Valve's native aarch64 client in gamepad UI.
  session = pkgs.writeShellScript "steam-session" ''
    set -eu
    export PATH=${
      lib.makeBinPath [
        pkgs.coreutils
        pkgs.gnugrep
        pkgs.gamescope
      ]
    }:$PATH
    exec > "$HOME/steam-session.log" 2>&1

    export STEAM_ARM64_ROOT="$HOME/.local/share/Steam"

    # First run only: the stock launcher unpacks the client, then fails in muvm
    # (this SoC has no /dev/kvm). The unpacking is all we need from it.
    if [ ! -x "$STEAM_ARM64_ROOT/steamrtarm64/steam" ]; then
      ${launcher} || true
    fi

    # 4K pages: skip the microVM and run the FHS wrapper directly.
    fhs=$(grep -o '/nix/store/[^"[:space:]]*-steam-arm64-fhs/bin/steam-arm64-fhs' ${launcher} | head -1)
    if [ ! -x "$fhs" ]; then
      echo "steam-arm64-fhs not found in ${launcher}"
      exec sleep infinity
    fi

    exec gamescope -e --prefer-output DSI-1 --force-orientation left -- "$fhs" -gamepadui
  '';
in
{
  nixpkgs.overlays = [ inputs.steam-arm64-nix.overlays.default ];
  nixpkgs.config.allowUnfree = true; # Valve's client

  programs.nix-ld.enable = true; # the client's binaries expect /lib/ld-linux-aarch64.so.1
  hardware.graphics.enable = true;
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
  environment.systemPackages = [ pkgs.mangohud ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # Controllers pair once (see README) and then reconnect on their own.
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
