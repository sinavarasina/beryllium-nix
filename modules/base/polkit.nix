# Authorisation rules for two things the Steam session touches from the console.
{
  security.polkit.enable = true;

  security.polkit.extraConfig = ''
    // Steam's Deck-mode Wi-Fi page scans and edits connections through
    // NetworkManager. The device has a single local user, so the active
    // console session may do all of it without a prompt (Jovian-NixOS does
    // the same).
    polkit.addRule(function(action, subject) {
      if (action.id.indexOf("org.freedesktop.NetworkManager.") == 0 &&
          subject.local && subject.active) {
        return polkit.Result.YES;
      }
    });

    // iio-sensor-proxy only lets an active local session claim a sensor, which
    // leaves out SSH. Members of plugdev may claim from anywhere, so
    // monitor-sensor can be tried over the USB gadget.
    polkit.addRule(function(action, subject) {
      if (action.id == "net.hadess.SensorProxy.claim-sensor" &&
          subject.isInGroup("plugdev")) {
        return polkit.Result.YES;
      }
    });
  '';
}
