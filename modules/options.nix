# The few knobs that differ between devices and owners. Values live in
# ../settings.nix; everything else reads them as config.beryllium.*.
{ lib, ... }:
{
  options.beryllium = {
    hostName = lib.mkOption {
      type = lib.types.strMatching "[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?";
      default = "beryllium";
      description = "Network host name.";
    };

    user = lib.mkOption {
      type = lib.types.strMatching "[a-z_][a-z0-9_-]*";
      example = "sina";
      description = "Login user. Also the account greetd logs into automatically.";
    };

    steam.deckMode = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Start Steam in Deck mode (-steamdeck -steamos3 -steampal on Valve's
        steamdeck_publicbeta aarch64 channel. This is what puts the Wi-Fi,
        Bluetooth and Quick Access pages in the Steam UI. Off gives plain
        Big Picture. The first start after turning it on downloads the 
        Deck-branch client and restarts once.
      '';
    };

    displayPanel = lib.mkOption {
      type = lib.types.enum [
        "tianma"
        "ebbg"
      ];
      description = ''
        Display panel fitted to this unit. The two POCO F1 panel vendors need
        different device trees; pick the one your phone has.
      '';
    };
  };
}
