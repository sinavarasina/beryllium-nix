# beryllium-nix

NixOS on a Xiaomi POCO F1 (beryllium) using
[vanilla-mobile-nixos](https://github.com/vanilla-mobile-nixos/vanilla-mobile-nixos).
Boots straight into Steam's gamepad UI (Valve's native aarch64 client inside gamescope).

## Layout

    settings.nix              hostname, user, display panel (edit this first)
    flake.nix                 inputs and the `beryllium` configuration
    hosts/beryllium/          host entry point and disk layout (btrfs, no LUKS)
    modules/base/             nix settings, user, sudo
    modules/hardware/         audio (PipeWire), Bluetooth, graphics
    modules/network/          SSH (password) and WiFi profiles
    modules/gaming/           Steam, gamescope, gamemode, session, MangoHud (+ its config)
    modules/tuning/           zram and sysctl, earlyoom, limits, ntsync

## Forks this flake depends on

- `sinavarasina/steam-arm64-nix`: `guest-run.sh` no longer filters out the Turnip Vulkan ICD.

## Build and flash

Needs Nix with `extra-platforms = aarch64-linux` and qemu binfmt on the build host.

    git add -A          # flakes only see tracked files
    nix build .#nixosConfigurations.beryllium.config.system.build.diskoImagesScript -o img-script
    nix build .#nixosConfigurations.beryllium.config.vanilla-mobile.deviceInfo.uboot -o uboot
    ./img-script        # writes nixos-boot.raw and nixos-root.raw

With the phone in fastboot mode:

    fastboot erase dtbo erase boot flash boot uboot/u-boot.img
    fastboot erase system flash system nixos-boot.raw
    fastboot erase userdata flash userdata nixos-root.raw
    fastboot reboot

## First boot

Connect USB, then `ssh <user>@172.16.42.1` (password `changeme`) and run `passwd`.

## Secrets

WiFi credentials stay out of git. On the phone:

    sudo install -d -m 700 /var/lib/secrets
    sudoedit /var/lib/secrets/wifi.env      # see wifi.env.example
    sudo chmod 600 /var/lib/secrets/wifi.env
    sudo systemctl restart NetworkManager-ensure-profiles

## Deploy

    git add -A
    nix fmt
    nix run nixpkgs#nixos-rebuild -- test --flake .#beryllium --target-host <user>@<ip> --sudo
    # happy? repeat with `switch` (or `boot`); older nixos-rebuild: --use-remote-sudo

`ssh-copy-id <user>@<ip>` once to avoid repeated password prompts.

## Gamepad

Pair once over SSH; it reconnects by itself afterwards.

    bluetoothctl
    > power on
    > agent on
    > default-agent
    > scan on
    > pair <MAC>
    > trust <MAC>
    > connect <MAC>

## Troubleshooting

- Session log: `~/steam-session.log`.
- `/dev/ntsync` or zram missing: the device kernel lacks the option, nothing to fix here.
