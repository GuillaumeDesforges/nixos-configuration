# nixos-configuration

Personal NixOS + home-manager flake for my laptops and desktops.

## Options

All under `gdforj.*`; defined alongside the code they gate.

- `gdforj.user.name` — primary account username (default `"gdforj"`)
- `gdforj.system.keyboardLayout` — XKB layout (default `"fr"`)
- `gdforj.docker.enable` — Docker daemon, `docker-compose`, user docker group
- `gdforj.desktop.enable` — networking, locale, xserver, SDDM, xdg-portal base
  - `gdforj.desktop.audio.enable` — PipeWire (default: `gdforj.desktop.enable`)
  - `gdforj.desktop.printing.enable` — CUPS + SANE + Avahi (default: `gdforj.desktop.enable`)
  - `gdforj.desktop.kde.enable` — Plasma 6 (default: `gdforj.desktop.enable`)
  - `gdforj.desktop.zsa.enable` — ZSA keyboard udev rules + `keymapp` (default: `gdforj.desktop.enable`)
- `gdforj.user.apps.<bundle>.enable` — per-bundle toggles: `claude`, `desktop`, `dev`, `gamedev`, `gaming`, `music`, `video`, `work`

## Usage

```sh
sudo nixos-rebuild switch --flake .#<hostname>
```

## Gaming on PRIME offload hosts (akame)

Hosts with `hardware.nvidia.prime.offload.enable` (like akame) default to the Intel iGPU for all rendering. To run a Steam game on the Nvidia GPU, set this in the game's **Launch Options** (right-click → Properties):

```
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only %command%
```

Or use the `nvidia-offload` wrapper (enabled via `offload.enableOffloadCmd = true` in `hardware.nix`) for non-Steam binaries:

```sh
nvidia-offload <binary>
```

## Adding a host

1. `nixos-generate-config --show-hardware-config > hosts/<name>/hardware.nix`
2. Create `hosts/<name>/default.nix` importing `./hardware.nix` and setting the relevant `gdforj.*` flags.
3. Add an entry in `flake.nix` calling `mkNixosSystem` with `config = ./hosts/<name>;`.

