{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mangohud ];

  home-manager.users.${config.beryllium.user}.xdg.configFile."MangoHud/MangoHud.conf".source =
    ./MangoHud.conf;
}
