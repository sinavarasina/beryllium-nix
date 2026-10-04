{ ... }:
{
  # Needs CONFIG_ZRAM in the device kernel; harmless if missing.
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };
  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "vm.page-cluster" = 0;
  };
  services.earlyoom.enable = true;

  # NT sync for Wine/Proton. Needs CONFIG_NTSYNC; check `ls /dev/ntsync` on the phone.
  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''KERNEL=="ntsync", MODE="0666"'';
}
