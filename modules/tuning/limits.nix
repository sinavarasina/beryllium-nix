{ lib, ... }:
{
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
