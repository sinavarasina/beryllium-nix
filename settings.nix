# Personal settings. None of this is secret: edit it, then rebuild.
# (Secrets such as WiFi credentials live in an env file on the device, see README.)
# Options and their types are declared in modules/options.nix.
{
  beryllium = {
    hostName = "beryllium";
    user = "sina";
    displayPanel = "tianma"; # "tianma" or "ebbg"
    usbDeveloper = true; # keep SSH over the USB cable after boot
    # Flashable images (see README, "Build and flash").
    image = {
      enable = false; # true only while building nixos-boot.raw / nixos-root.raw
      buildSystem = "x86_64-linux"; # the PC that builds them
      bootSize = "2G";
      rootSize = "4G";
    };
    steam.deckMode = true; # Wi-Fi and Bluetooth pages in the Steam UI
  };
}
