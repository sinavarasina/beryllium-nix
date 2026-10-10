{ config, ... }:
{
  users.users.${config.beryllium.user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "input"
      "audio"
      "plugdev"
    ];
    # Only used when the account is first created. Run `passwd` after the first login.
    initialPassword = "changeme";
  };

  # The group the sensor polkit rule (polkit.nix) matches; NixOS has no plugdev by default.
  users.groups.plugdev = { };

  # Single-user device: lets `nixos-rebuild --sudo` run without a prompt.
  security.sudo.wheelNeedsPassword = false;
}
