{ config, pkgs, ... }:
{
  environment.systemPackages = [ pkgs.mangohud ];

  home-manager.users.${config.beryllium.user}.xdg.configFile."MangoHud/MangoHud.conf".text = ''
    ${builtins.readFile ./MangoHud.conf}
    output_folder=/home/${config.beryllium.user}
  '';
}
