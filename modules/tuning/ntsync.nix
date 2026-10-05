# Needs a kernel built with CONFIG_NTSYNC; without it the module load is a no-op.
{
  boot.kernelModules = [ "ntsync" ];
  services.udev.extraRules = ''KERNEL=="ntsync", MODE="0666"'';
}
