{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.JustWorksRepairing = "always";
  };

  # Disable Bluetooth ERTM (Enhanced Retransmission Mode) for Xbox/8BitDo Bluetooth controllers.
  # When ERTM is enabled, HIDP GET_REPORT requests time out every few seconds, causing sysfs
  # battery queries (/sys/class/power_supply/hid-*/capacity) to block for 4-6s and stutter MangoHud.
  boot.extraModprobeConfig = ''
    options bluetooth disable_ertm=Y
  '';
}
