{ config, ... }:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${config.beryllium.user}.home.stateVersion = "26.05";
  };
}
