{
  config,
  lib,
  pkgs,
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
      gamescope
    ];
    text = ''
      exec > "$HOME/steam-session.log" 2>&1

      export STEAM_ARM64_ROOT="$HOME/.local/share/Steam"

      exec gamescope -e \
        --prefer-output DSI-1 \
        --force-orientation left \
        -- \
        ${lib.getExe steam} -gamepadui
    '';
  };

  autologin = {
    command = lib.getExe session;
    user = config.beryllium.user;
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
