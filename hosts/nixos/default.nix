{
  config,
  dotdir,
  inputs,
  lib,
  pkgs,
  secrets,
  ...
}: {
  imports = [
    ./hardware.nix
    ../../modules/fonts
    inputs.home-manager.nixosModules.default
    inputs.nixos-apple-silicon.nixosModules.default
  ];

  boot = {
    tmp.cleanOnBoot = true;
    m1n1CustomLogo = ../../assets/bootlogo-m1n1.png;
    loader = {
      timeout = 2;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
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
      "networkmanager"
      "wheel"
      # "audio"
      # "video"
      # "libvirtd"
      # "docker"
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
      imports = [./home.nix];
    };
  };

  # environment.pathsToLink = [
  #   "/share/zsh"
  #   "/share/qemu"
  #   "/share/edk2"
  # ];

  nix.settings = {
    access-tokens = ["github=${secrets.github.api}"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    trusted-users = ["quinn" "root"];
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
  };

  # virtualisation
  virtualisation = {
    podman.enable = false;
    libvirtd.enable = false;
  };

  programs.dconf.enable = true;

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
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
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

  security.sudo.wheelNeedsPassword = false;

  services = {
    dbus.enable = true;
    blueman.enable = true;
    flatpak.enable = true;
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us";
    };
  };

  environment.sessionVariables = {
    WLR_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    NIXOS_CONFIG = "/home/quinn/.dotfiles";
  };

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
