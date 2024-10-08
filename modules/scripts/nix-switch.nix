{
  pkgs,
  lib,
  ...
}: let
  nix-switch = pkgs.writeShellScriptBin "nix-switch" ''
    sudo nixos-rebuild switch --flake $HOME/.dotfiles#nixos $@
  '';
in {home.packages = lib.mkIf pkgs.stdenv.isLinux [nix-switch];}
