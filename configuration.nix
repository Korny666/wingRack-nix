{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "x32-edit" ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.x32edit
    pkgs.vim
    pkgs.neovim
    pkgs.xlibinput-calibrator
  ];

  users.users = {
    root.openssh.authorizedKeys.keys = [
      # change this to your ssh key
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGlarC74eYa7awOoGCcTihwuA6enoYcx59TAFxLlJr6b daniel@x1e"
    ];

    x32 = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$xnLgqOHMUHdmKH0h8606B.$7e9iyQuPafHK9I3STaT/OyYx1SEbthvIctZPEZ3pSTC";
    };
  };

  # Enable the X11 windowing system.
  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "de";
        options = "eurosign:e";
      };
      windowManager.i3 = {
        enable = true;
        configFile = ./i3-config;
      };
    };
    libinput.enable = true;
    udev.extraRules =
      let
        defaultCalibrationMatrix = "1.03 0 -0.015 0 1.02 -0.01";
        eloTouchScreen = ''ENV{ID_VENDOR_ID}=="04e7", ENV{ID_MODEL_ID}=="0020"'';
      in
      ''
        KERNEL=="event*", ${eloTouchScreen}, ENV{LIBINPUT_CALIBRATION_MATRIX}="${defaultCalibrationMatrix}"
      '';
    displayManager.autoLogin = {
      enable = true;
      user = "x32";
    };
  };

  system.stateVersion = "24.11";
}
