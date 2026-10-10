{
  config,
  lib,
  pkgs,
  ...
}:
let
  steam = pkgs.steam-arm64.override { useMuvm = false; };
  deckMode = config.beryllium.steam.deckMode;

  # Start the client with -gamepadui -steamos3 -steampal
  # -steamdeck; the Deck pages (Wi-Fi, Bluetooth) only exist in that mode.
  # steamdeck_publicbeta is the Deck channel Valve publishes for aarch64, and
  # steam-arm64 records it in package/beta when it sees -clientbeta.
  clientArgs = [
    "-gamepadui"
  ]
  ++ lib.optionals deckMode [
    "-steamos3"
    "-steampal"
    "-steamdeck"
    "-clientbeta"
    "steamdeck_publicbeta"
  ];

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
      ${lib.optionalString deckMode ''
        # WirePlumber picks the output device (hardware/audio.nix); keep the
        # Deck UI's own switching out of the way.
        export STEAM_DISABLE_AUDIO_DEVICE_SWITCHING=1
      ''}
      exec gamescope -e \
        --prefer-output DSI-1 \
        --force-orientation left \
        -- \
        ${lib.getExe steam} ${lib.escapeShellArgs clientArgs}
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
