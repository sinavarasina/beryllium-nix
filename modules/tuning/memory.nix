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
}
