# wingRack-nix

wingRack edit behringer nixos machine config

with mixing-station

Use this for all other targets

**Fist time without hardware-configuration:**

    nixos-anywhere --flake .#nixos --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>

**full reinstall with existing hardware-configuration:**

    nixos-anywhere --flake .#nixos <hostname>

**updates as usual with:**

    nixos-rebuild --flake .\#nixos --target-host root@<hostname> boot
