{ pkgs, ... }:

{
  # Wait for Qualcomm SDSP FastRPC daemon to finish opening sensor registry files
  # before iio-sensor-proxy probes libssc at boot.
  systemd.services.iio-sensor-proxy = {
    after = [ "hexagonrpcd-sdsp.service" ];
    wants = [ "hexagonrpcd-sdsp.service" ];
    serviceConfig.ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
  };
}
