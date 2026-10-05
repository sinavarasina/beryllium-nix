{ ... }:
let
  # Credentials never live in the repo: NetworkManager substitutes $VARS from an
  # env file kept on the device (see README, "Secrets").
  wifiProfile =
    {
      id,
      ssid,
      band,
      priority,
    }:
    {
      connection = {
        inherit id;
        type = "wifi";
        autoconnect-priority = priority;
      };
      wifi = {
        inherit ssid band;
        mode = "infrastructure";
        hidden = true;
      };
      wifi-security = {
        key-mgmt = "wpa-psk";
        psk = "$WIFI_PSK";
      };
    };
in
{
  networking.networkmanager = {
    enable = true;
    ensureProfiles = {
      environmentFiles = [ "/var/lib/secrets/wifi.env" ];
      profiles = {
        wifi-5g = wifiProfile {
          id = "wifi-5g";
          ssid = "$WIFI_SSID_5G";
          band = "a";
          priority = 20;
        };
        wifi-24g = wifiProfile {
          id = "wifi-24g";
          ssid = "$WIFI_SSID_24G";
          band = "bg";
          priority = 10;
        };
      };
    };
  };
}
