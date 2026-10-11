# USB network for SSH without Wi-Fi.
#
# vanilla-mobile starts usb-moded in rescue mode, which exposes the USB network,
# and switches to its default mode (charging only) once the session is up. The
# only way back to the network from there is a notification asking for
# "Developer", and the Steam session has no notification daemon to show it.
# Making developer_mode the default keeps the link up after boot.
{ config, lib, ... }:
{
  services.usb-moded.settings.usbmode.mode = lib.mkIf config.beryllium.usbDeveloper "developer_mode";
}
