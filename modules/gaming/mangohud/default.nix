{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.mangohud
  ];

  environment.etc."mangohud/MangoHud.conf".source =
    ./MangoHud.conf;
}
