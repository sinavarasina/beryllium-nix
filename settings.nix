# Personal settings. None of this is secret: edit it, then rebuild.
# (Secrets such as WiFi credentials live in an env file on the device, see README.)
# Options and their types are declared in modules/options.nix.
{
  beryllium = {
    hostName = "beryllium";
    user = "sina";
    displayPanel = "tianma"; # "tianma" or "ebbg"
    usbDeveloper = false; # keep SSH over the USB cable (172.16.42.1) after boot
    steam.deckMode = true; # Wi-Fi and Bluetooth pages in the Steam UI
    image = {
      bootSize = "2G";
      rootSize = "12G";
    };
  };
}
