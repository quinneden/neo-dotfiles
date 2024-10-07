{pkgs, lib, ...}: let
  symlink = pkgs.writeShellScript "symlink" ''
    if [[ "$1" == "-r" ]]; then
      rm -rf "$HOME/.config/ags"
    fi

    if [[ "$1" == "-a" ]]; then
      rm -rf "$HOME/.config/ags"
      ln -s "$HOME/.dotfiles/ags" "$HOME/.config/ags"
    fi
  '';
  nix-switch = pkgs.writeShellScriptBin "nix-switch" ''
    rm -rf "$HOME/.config/ags"
    sudo nixos-rebuild switch --flake $HOME/.dotfiles#nixos-macmini --impure $@
    rm -rf "$HOME/.config/ags"
    ln -s "$HOME/.dotfiles/ags" "$HOME/.config/ags"
  '';
  nix-boot = pkgs.writeShellScriptBin "nix-boot" ''
    ${symlink} -r
    sudo nixos-rebuild boot --flake $HOME/.dotfiles#nixos-macmini --impure $@
    ${symlink} -a
  '';
  nix-test = pkgs.writeShellScriptBin "nix-test" ''
    ${symlink} -r
    sudo nixos-rebuild test --flake $HOME/.dotfiles#nixos-macmini --impure $@
    ${symlink} -a
  '';
in {home.packages = lib.mkIf pkgs.stdenv.isLinux [nix-switch nix-boot nix-test];}
