{ settings, ... }:
{
  users.users.${settings.user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "render"
      "input"
      "audio"
    ];
    # Only used when the account is first created. Run `passwd` after the first login.
    initialPassword = "changeme";
  };

  # Single-user device: lets `nixos-rebuild --sudo` run without a prompt.
  security.sudo.wheelNeedsPassword = false;
}
