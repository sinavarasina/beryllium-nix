{ config, inputs, ... }:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.beryllium.user}.home.stateVersion = config.system.stateVersion;
  };
}
