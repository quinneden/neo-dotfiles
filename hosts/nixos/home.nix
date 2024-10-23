{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    # ../../modules/home-manager
    ../../modules/hm-new
  ];

  nixpkgs = {
    allowUnfree = true;
    allowInsecure = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
    overlays = [ inputs.nur.overlay ];
  };

  nixpkgs.config.permittedInsecurePackages = [
    "electron-25.9.0"
  ];

  programs.home-manager.enable = true;
  # wal.enable = true;

  home.file.".wallpapers" = {
    source = ../../modules/hm-new/images/walls;
    recursive = true;
  };

  home.file.".local/share/fonts".source = ../../modules/hm-new/fonts;

  # gtk themeing
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "Papirus";
    theme.name = "phocus";
  };

  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch aura https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/eww" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch glacier https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/eww
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/chadcat7/kodo ${config.home.homeDirectory}/.config/nvim
        fi
      '';
    };
    packages = with pkgs; [
      bc
      git-lfs
      feh
      sway-contrib.grimshot
      xss-lock
      authy
      go
      gopls
      playerctl
      (pkgs.callPackage ../../pkgs/icons/papirus.nix { })
      (pkgs.callPackage ../../pkgs/others/phocus.nix { inherit colors; })
      cinnamon.nemo
      i3lock-color
      rust-analyzer
      mpc-cli
      ffmpeg_5-full
      libdbusmenu-gtk3
      xdg-desktop-portal
      imagemagick
      xorg.xev
      procps
      obsidian
      moreutils
      mpdris2
      socat
      inputs.matugen.packages.${system}.default
      inputs.swayhide.packages.${system}.default
      pavucontrol
      swww
      swayidle
      autotiling-rs
      pywal
      slurp
      sassc
    ];

    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
      XDG_CACHE_HOME = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME = "${config.home.homeDirectory}/.local/state";
    };
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.stateVersion = "24.11";
}
