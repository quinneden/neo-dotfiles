{
  config,
  dotdir,
  inputs,
  lib,
  pkgs,
  self,
  secrets,
  ...
}:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  my-python-packages =
    ps: with ps; [
      material-color-utilities
      numpy
      i3ipc
    ];
in
{
  imports = [
    ./hardware.nix
    ../../modules/fonts
    inputs.home-manager.nixosModules.default
    inputs.nixos-apple-silicon.nixosModules.default
  ];

  boot = {
    tmp.cleanOnBoot = true;
    m1n1CustomLogo = ../../assets/bootlogo-m1n1.png;
    # loader = {
    #   timeout = 2;
    #   systemd-boot.enable = true;
    #   efi.canTouchEfiVariables = false;
    # };
    loader = {
      efi.efiSysMountPoint = "/boot/efi";
      systemd-boot.enable = false;
      grub.enable = true;
      grub.efiSupport = true;
      grub.device = "nodev";
      grub.darkmatter-theme = {
        enable = true;
        style = "nixos";
      };
    };
  };

  hardware.asahi = {
    withRust = true;
    setupAsahiSound = true;
    useExperimentalGPUDriver = true;
    experimentalGPUInstallMode = "replace";
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "https://qeden.me/asahi-firmware.tar.gz";
      sha256 = "sha256-tsRkDsXr7NYsNLJoWHBd6xaybtT+SVw+9HYn4zQmezo=";
    };
  };

  users.users.quinn = {
    isNormalUser = true;
    shell = "${pkgs.zsh}/bin/zsh";
    extraGroups = [
      "adbusers"
      "audio"
      "libvirtd"
      "networkmanager"
      "video"
      "wheel"
    ];
  };

  time.timeZone = "America/Los_Angeles";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  console.useXkbConfig = true;

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotdir secrets;
    };
    users.quinn = {
      home.username = "quinn";
      home.homeDirectory = "/home/quinn";
      imports = [ ./home.nix ];
    };
  };

  # environment.pathsToLink = [
  #   "/share/zsh"
  #   "/share/qemu"
  #   "/share/edk2"
  # ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nixpkgs-f2k.overlays.compositors
      inputs.nur.overlay
      (final: prev: {
        awesome = inputs.nixpkgs-f2k.packages.${pkgs.system}.awesome-git;
      })
    ];
    config = {
      allowUnfreePredicate = _: true;
      allowUnfree = true;
    };
  };

  nix.settings = {
    access-tokens = [ "github=${secrets.github.api}" ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [
      "quinn"
      "root"
    ];
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    warn-dirty = false;
    extra-substituters = [
      "${secrets.cachix.nixos-asahi.url}"
      "${secrets.cachix.quinneden.url}"
      "https://cache.lix.systems"
      "https://hyprland.cachix.org"
    ];
    extra-trusted-public-keys = [
      "${secrets.cachix.nixos-asahi.public-key}"
      "${secrets.cachix.quinneden.public-key}"
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };

  # virtualisation
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  programs.adb.enable = true;

  programs.dconf.enable = true;

  programs.nix-ld.enable = true;

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  programs.direnv = {
    package = pkgs.direnv;
    silent = false;
    enableZshIntegration = true;
    loadInNixShell = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  programs.ssh.startAgent = true;

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-wlr
    ];
  };

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  environment.systemPackages = with pkgs; [
    asahi-bless
    asahi-btsync
    alejandra
    apfsprogs
    hfsprogs
    btrfs-progs
    micro
    ripgrep
    git
    wget
  ];

  security = {
    rtkit.enable = true;
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
    pam.services.gdm.enableGnomeKeyring = true;
    pam.services.swaylock = {
      text = ''
        auth include login
      '';
    };
  };

  location.provider = "geoclue2";

  services = {
    dbus.enable = true;
    gvfs.enable = true;
    tlp.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      layout = "us";
      xkbVariant = "us";
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          middleEmulation = false;
          naturalScrolling = true;
        };
      };
      displayManager = {
        defaultSession = "none+awesome";
        startx.enable = true;
      };
      windowManager.awesome = {
        enable = true;
      };
      desktopManager.gnome.enable = false;
    };
  };

  environment.sessionVariables = {
    WLR_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    NIXOS_CONFIG = "/home/quinn/.dotfiles";
  };

  environment.systemPackages = with pkgs; [
    nodejs
    lutgen
    bluez
    unzip
    bluez-tools
    inotify-tools
    udiskie
    rnix-lsp
    xorg.xwininfo
    brightnessctl
    networkmanager_dmenu
    (pkgs.python311.withPackages my-python-packages)
    libnotify
    xdg-utils
    gtk3
    niv
    st
    appimage-run
    jq
    osu-lazer
    imgclr
    grim
    slop
    eww-wayland
    swaylock-effects
    pstree
    mpv
    xdotool
    brightnessctl
    pamixer
    dmenu
    python3
    brillo
    wmctrl
    slop
    imv
    element-desktop
    maim
    xclip
    wirelesstools
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xorgserver
    xorg.xf86videoati
  ];

  fonts.packages = with pkgs; [
    material-design-icons
    dosis
    material-symbols
    rubik
    noto-fonts-color-emoji
    google-fonts
  ];
  fonts.fontconfig = {
    defaultFonts = {
      sansSerif = [ "Product Sans" ];
      monospace = [ "Iosevka Nerd Font" ];
    };
  };
  fonts.enableDefaultPackages = true;

  networking = {
    hostName = "nixos-macmini";
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd = {
      enable = true;
      settings.General.EnableNetworkConfiguration = true;
    };
    firewall.enable = false;
    hostId = "a25f4bea";
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings.General.Experimental = true;
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  system.stateVersion = "24.11";
}
