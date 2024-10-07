{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../home-manager/ags.nix
    ../home-manager/blackbox.nix
    ../home-manager/browser.nix
    ../home-manager/dconf.nix
    ../home-manager/distrobox.nix
    ../home-manager/firefox.nix
    ../home-manager/git.nix
    ../home-manager/hyprland.nix
    ../home-manager/lf.nix
    ../home-manager/micro.nix
    ../home-manager/packages.nix
    ../home-manager/sh.nix
    ../home-manager/starship.nix
    ../home-manager/theme.nix
    ../home-manager/tmux.nix
    ../home-manager/wezterm.nix
    ../home-manager/alacritty.nix
    ../home-manager/kitty.nix
    ../home-manager/vscodium.nix
  ];

  home = {
    sessionVariables = {
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
      BAT_THEME = "base16";
      GOPATH = "${config.home.homeDirectory}/.local/share/go";
      GOMODCACHE = "${config.home.homeDirectory}/.cache/go/pkg/mod";
      XDG_CACHE_HOME  = "${config.home.homeDirectory}/.cache";
      XDG_CONFIG_HOME = "${config.home.homeDirectory}/.config";
      XDG_DATA_HOME = "${config.home.homeDirectory}/.local/share";
      XDG_STATE_HOME  = "${config.home.homeDirectory}/.local/state";
    };

    sessionPath = [
      "$HOME/.local/bin"
    ];
  };

  home.stateVersion = "24.11";
}
