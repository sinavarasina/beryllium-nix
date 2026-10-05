{ config, inputs, ... }:
{
  imports = [
    inputs.vanilla-mobile-nixos.nixosModules.vanilla-mobile
    inputs.disko.nixosModules.disko
    ./disko.nix
    ../../modules/options.nix
    ../../modules/base
    ../../modules/hardware
    ../../modules/network
    ../../modules/gaming
    ../../modules/tuning
  ];

  networking.hostName = config.beryllium.hostName;

  vanilla-mobile = {
    cache.enable = true;
    device.xiaomi-beryllium = {
      enable = true;
      inherit (config.beryllium) displayPanel;
    };
  };

  nixpkgs.config.allowUnfreePackages = [ "xiaomi-beryllium-firmware" ];

  system.stateVersion = "26.05";
}
