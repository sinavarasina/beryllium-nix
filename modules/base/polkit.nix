# Authorisation rules for actions the Steam session and SSH user touch.
{
  security.polkit = {
    enable = true;

    extraConfig = ''
      // Steam's Deck-mode UI manages connections through NetworkManager and
      // sets the timezone and hostname over the system bus via steamos-stubs.
      // The device has a single local user, so the active console session may
      // do all of it without a prompt (Jovian-NixOS does the same).
      polkit.addRule(function(action, subject) {
        if ((action.id.indexOf("org.freedesktop.NetworkManager.") == 0 ||
             action.id == "org.freedesktop.timedate1.set-timezone" ||
             action.id == "org.freedesktop.hostname1.set-hostname" ||
             action.id == "org.freedesktop.hostname1.set-static-hostname") &&
            subject.local && subject.active) {
          return polkit.Result.YES;
        }
      });

      // iio-sensor-proxy only lets an active local session claim a sensor, which
      // leaves out SSH. Wheel users may claim from anywhere, so monitor-sensor
      // can be tested over SSH.
      polkit.addRule(function(action, subject) {
        if (action.id == "net.hadess.SensorProxy.claim-sensor" &&
            subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };
}
