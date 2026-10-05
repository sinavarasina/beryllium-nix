# Boots straight into Steam's gamepad UI inside gamescope.
{
  lib,
  pkgs,
  settings,
  ...
}:
let
  steam = pkgs.steam-arm64.override { useMuvm = false; };

  session = pkgs.writeShellApplication {
    name = "steam-session";
    runtimeInputs = with pkgs; [
      coreutils
      gnugrep
      gnused
    ];
    text = ''
      exec > "$HOME/steam-session.log" 2>&1

      export STEAM_ARM64_ROOT="$HOME/.local/share/Steam"
      export MANGOHUD_CONFIGFILE=/etc/mangohud/MangoHud.conf

      # The capability wrapper (programs.gamescope.capSysNice), not
      # pkgs.gamescope: only the wrapper may raise its own priority.
      exec /run/wrappers/bin/gamescope -e --mangoapp \
        --prefer-output DSI-1 --force-orientation left -- \
        ${lib.getExe steam} -gamepadui
    '';
  };

  autologin = {
    command = lib.getExe session;
    user = settings.user;
  };
in
{
  services.greetd = {
    enable = true;
    settings = {
      initial_session = autologin;
      default_session = autologin;
    };
  };
}
