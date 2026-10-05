{ inputs, settings, ... }:
{
  imports = [
    inputs.vanilla-mobile-nixos.nixosModules.vanilla-mobile
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../modules/base
    ../../modules/hardware
    ../../modules/network
    ../../modules/gaming
    ../../modules/tuning
  ];

  networking.hostName = settings.hostName;

  vanilla-mobile = {
    cache.enable = true;
    device.xiaomi-beryllium = {
      enable = true;
      inherit (settings) displayPanel;
    };
  };

  nixpkgs.config.allowUnfreePackages = [ "xiaomi-beryllium-firmware" ];

  system.stateVersion = "26.05";
}
