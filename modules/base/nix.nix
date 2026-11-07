{
  # Needed for xiaomi-beryllium-firmware and Valve's Steam client.
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    # Lets `nixos-rebuild --target-host` work as a wheel user.
    trusted-users = [
      "root"
      "@wheel"
    ];
  };
}
