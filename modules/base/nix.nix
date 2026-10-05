{
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
