{
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.extraConfig."52-headphones-priority" = {
      "monitor.alsa.rules" = [
        {
          matches = [ { "node.name" = "alsa_output.platform-sound.HiFi__Headphones__sink"; } ];
          actions.update-props = {
            "priority.session" = 1500;
            "priority.driver" = 1500;
          };
        }
      ];
    };
  };
}
