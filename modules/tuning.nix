{ lib, ... }:
{
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 150;
    "vm.page-cluster" = 0;
    "vm.max_map_count" = 1048576;
  };

  services.earlyoom.enable = true;

  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''KERNEL=="ntsync", MODE="0666"'';

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "1048576";
    }
    {
      domain = "*";
      type = "-";
      item = "nice";
      value = "-20";
    }
  ];

  systemd.settings.Manager.DefaultLimitNOFILE = lib.mkForce "1048576";
  systemd.user.settings.Manager.DefaultLimitNOFILE = lib.mkForce "1048576";
}
