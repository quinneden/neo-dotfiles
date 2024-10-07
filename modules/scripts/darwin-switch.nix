{pkgs, lib, ...}: let
  darwin-switch = pkgs.writeShellScriptBin "darwin-switch" ''
    /run/current-system/sw/bin/darwin-rebuild switch --flake $HOME/.dotfiles#macos "$@"
  '';
in {home.packages = lib.mkIf pkgs.stdenv.isDarwin [darwin-switch];}
