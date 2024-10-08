{
  pkgs,
  lib,
  ...
}: {
  imports =
    lib.mkMerge (mkIf pkgs.stdenv.isLinux [
      ./ags
      ./alacritty
      ./distrobox
      ./extra
      ./firefox
      ./gtk
      ./hyprland
      ./kitty
      ./pywal
      ./rofi
      ./tmux
      ./vscodium
    ])
    ++ [
      ./git
      ./packages
      ./zsh
    ];
}
