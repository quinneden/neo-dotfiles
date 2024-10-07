{
  config,
  dotdir,
  secrets,
  inputs,
  pkgs,
  lib,
  ...
}: let
  username = "quinn";
in {
  imports = [
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
    experimentalGPUInstallMode = "overlay";
    peripheralFirmwareDirectory = builtins.fetchTarball {
      url = "https://qeden.me/asahi-firmware.tar.gz";
      sha256 = "sha256-tsRkDsXr7NYsNLJoWHBd6xaybtT+SVw+9HYn4zQmezo=";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = username;
    shell = "${pkgs.zsh}/bin/zsh";
    extraGroups = [
      "networkmanager"
      "wheel"
      # "audio"
      # "video"
      "libvirtd"
      "docker"
    ];
  };

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs dotdir secrets;};
    users.${username} = {
      home.username = username;
      home.homeDirectory = "/home/${username}";
      imports = [
        ./home.nix
      ];
    };
  };

  environment.pathsToLink = [
    "/share/zsh"
    "/share/qemu"
    "/share/edk2"
  ];

  nix.settings = {
    access-tokens = ["github=${secrets.github.api}"];
    experimental-features = ["nix-command" "flakes"];
    auto-optimise-store = true;
    trusted-users = ["quinn" "root"];
    extra-nix-path = "nixpkgs=flake:nixpkgs";
    warn-dirty = false;
    extra-substituters = [
      "${secrets.cachix.nixos-asahi.url}"
      "https://cache.lix.systems"
    ];
    extra-trusted-public-keys = [
      "${secrets.cachix.nixos-asahi.public-key}"
      "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
    ];
  };

  # virtualisation
  virtualisation = {
    podman.enable = true;
    libvirtd.enable = true;
  };

  programs.dconf.enable = true;

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
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
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
    neovim
    git
    wget
  ];

  security.sudo.wheelNeedsPassword = false;

  services = {
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
