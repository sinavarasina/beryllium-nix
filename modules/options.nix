# The few knobs that differ between devices and owners. Values live in
# ../settings.nix; everything else reads them as config.beryllium.*.
{ lib, ... }:
{
  options.beryllium = {
    hostName = lib.mkOption {
      type = lib.types.strMatching "[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?";
      default = "beryllium";
      description = "Network host name.";
    };

    user = lib.mkOption {
      type = lib.types.strMatching "[a-z_][a-z0-9_-]*";
      example = "sina";
      description = "Login user. Also the account greetd logs into automatically.";
    };

    displayPanel = lib.mkOption {
      type = lib.types.enum [
        "tianma"
        "ebbg"
      ];
      description = ''
        Display panel fitted to this unit. The two POCO F1 panel vendors need
        different device trees; pick the one your phone has.
      '';
    };
  };
}
