{pkgs, ...}: let
  nish = pkgs.writeShellScriptBin "nish" ''
    if [[ $# -ge 1 ]]; then
      if [[ ! $p =~ - ]]; then
        for p in $@; do
          pkgs+="nixpkgs#$p "
        done
      else
        for p in $(echo $@ | sed s/"\-.\b "/""/g); do
          pkgs+="nixpkgs#$p "
        done
      fi
      nix shell "$pkgs"
    elif [[ ! -f ./flake.nix && ! -f ../flake.nix ]]; then
      nix shell nixpkgs#stdenv
    else
      nix shell
    fi
  '';
in {
  home.packages = [nish];
}
