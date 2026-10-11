# beryllium-nix

NixOS on a Xiaomi POCO F1 (beryllium) using
[vanilla-mobile-nixos](https://github.com/vanilla-mobile-nixos/vanilla-mobile-nixos).
Boots straight into Steam's gamepad UI (Valve's native aarch64 client inside gamescope).

## Layout

    settings.nix              hostname, user, display panel, image mode (edit this first)
    modules/options.nix       declares those settings as typed options
    flake.nix                 inputs and the `beryllium` configuration
    hosts/beryllium/          host entry point and disk layout (btrfs, no LUKS)
    modules/base/             nix settings, user, sudo, home-manager, polkit rules
    modules/hardware/         audio (PipeWire), Bluetooth, graphics
    modules/network/          SSH (password) and WiFi profiles
    modules/gaming/           Steam, gamescope, gamemode, session, MangoHud (+ its config)
    modules/tuning/           zram and sysctl, earlyoom, limits, ntsync

## Checks

`nix flake check --no-build` verifies formatting and evaluates the whole system,
so a bad setting (say `displayPanel = "foo"`) fails here and not on the phone.
CI runs it on every push; the slow qemu build is a manual workflow.

## Forks this flake depends on

- `sinavarasina/steam-arm64-nix`: `guest-run.sh` no longer filters out the Turnip Vulkan ICD.

## Build and flash

Needs Nix with `extra-platforms = aarch64-linux` and qemu binfmt on the PC, and
the Cachix substituter (`vanilla-mobile-nixos.cachix.org`) trusted, or the
kernel is built from source.

1. In `settings.nix` set `image.enable = true` (and `image.buildSystem` to the
   PC's system if it is not x86_64). Image mode makes the image VM run natively
   on the PC instead of emulating a whole aarch64 machine. Sizes are
   `image.bootSize` (vfat, cannot grow later) and `image.rootSize` (grows on
   first boot); raise `rootSize` if the build runs out of space.
2. Build and generate the images:

       git add -A          # flakes only see tracked files
       nix build .#images-script -o img-script
       nix build .#uboot -o uboot
       ./img-script        # writes nixos-boot.raw and nixos-root.raw

3. With the phone in fastboot mode (this erases the phone's userdata):

       fastboot erase dtbo erase boot flash boot uboot/u-boot.img
       fastboot erase system flash system nixos-boot.raw
       fastboot erase userdata flash userdata nixos-root.raw
       fastboot reboot

4. Set `image.enable = false` again. It is only for the PC build; updates to a
   running phone go through "Deploy" below.

## First boot

Connect USB, then `ssh <user>@172.16.42.1` (password `changeme`) and run `passwd`.
This needs `usbDeveloper = true` in `settings.nix` (the default here); without it
the phone drops the USB network once Steam is up and only Wi-Fi SSH remains.

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
