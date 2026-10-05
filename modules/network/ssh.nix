{
  services.openssh = {
    enable = true; # opens port 22 on every interface (USB gadget and WiFi)
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
}
