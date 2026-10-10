# Personal settings. None of this is secret: edit it, then rebuild.
# (Secrets such as WiFi credentials live in an env file on the device, see README.)
# Options and their types are declared in modules/options.nix.
{
  beryllium = {
    hostName = "beryllium";
    user = "sina";
    displayPanel = "tianma"; # "tianma" or "ebbg"
    steam.deckMode = true; # Wi-Fi and Bluetooth pages in the Steam UI
  };
}
