# beryllium-nix

NixOS on a Xiaomi POCO F1 (beryllium) using
[vanilla-mobile-nixos](https://github.com/vanilla-mobile-nixos/vanilla-mobile-nixos).
Boots straight into Steam's gamepad UI (Valve's native aarch64 client inside gamescope).

## Layout

    settings.nix              hostname, user, display panel, USB & Deck mode, image sizes (edit this first)
    modules/options.nix       declares those settings as typed options
    flake.nix                 inputs and the `beryllium` configuration
    hosts/beryllium/          host entry point and disk layout (btrfs, no LUKS)
    modules/base/             nix settings, user, sudo, home-manager, polkit rules
    modules/hardware/         audio (PipeWire), Bluetooth, graphics
    modules/network/          SSH (password), USB gadget mode, and WiFi profiles
    modules/gaming/           Steam, gamescope, gamemode, session, MangoHud (+ its config)
    modules/tuning/           zram and sysctl, earlyoom, limits, ntsync

## Checks

`nix flake check --no-build` verifies formatting and evaluates the whole system,
so a bad setting (say `displayPanel = "foo"`) fails here and not on the phone.
CI runs it on every push; the slow qemu build is a manual workflow.

## Forks this flake depends on

- `sinavarasina/steam-arm64-nix` (`deck-mode`): `guest-run.sh` no longer filters out the Turnip Vulkan ICD, and `steamos-stubs.nix` provides Deck-mode SteamOS helper scripts.
- `JuneStepp/disko` (`mobile`): disko image builder adjustments for mobile devices ([disko#1008](https://github.com/nix-community/disko/pull/1008)).

## Build and flash

Needs Nix with `extra-platforms = aarch64-linux` and qemu binfmt on the PC, and
the Cachix substituter (`vanilla-mobile-nixos.cachix.org`) trusted, or the
kernel is built from source.

1. Review `settings.nix` (`displayPanel`, `user`, etc.). Image sizes are
   `image.bootSize` (vfat, cannot grow later) and `image.rootSize` (grows on
   first boot); raise `rootSize` if the build runs out of space. The
   `.#images-script` package automatically runs the disko VM natively on the
   build PC (`x86_64-linux` or `aarch64-linux`).
2. Build and generate the images:

       git add -A          # flakes only see tracked files
       nix build '.#images-script' -o img-script
       nix build '.#uboot' -o uboot
       ./img-script        # writes nixos-boot.raw and nixos-root.raw

3. With the phone in fastboot mode (this erases the phone's userdata):

       fastboot erase dtbo erase boot flash boot uboot/u-boot.img
       fastboot erase system flash system nixos-boot.raw
       fastboot erase userdata flash userdata nixos-root.raw
       fastboot reboot

## First boot

Set `usbDeveloper = true` in `settings.nix` if you want to keep the USB network
up after boot (`ssh <user>@172.16.42.1`, initial password `changeme`, then run
`passwd`). When `usbDeveloper = false`, the phone switches USB to charging-only
once the Steam session starts and SSH is over Wi-Fi only.

## Secrets

WiFi credentials stay out of git. On the phone:

    sudo install -d -m 700 /var/lib/secrets
    sudoedit /var/lib/secrets/wifi.env      # see wifi.env.example
    sudo chmod 600 /var/lib/secrets/wifi.env
    sudo systemctl restart NetworkManager-ensure-profiles

## Deploy

    git add -A
    nix fmt
    nix run 'nixpkgs#nixos-rebuild' -- test --flake '.#beryllium' --target-host <user>@<ip> --sudo
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
