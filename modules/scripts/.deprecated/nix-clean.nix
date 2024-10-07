{pkgs, ...}: let
  nix-clean = pkgs.writeShellScriptBin "nix-clean" ''
    garbage_collect() {
      if [[ -e /nix/var/nix/gcroots/auto ]]; then
        sudo rm -rf /nix/var/nix/gcroots/auto
      fi

      read -r str1 < <(sudo nix store gc 2>/dev/null | tail -n 1)
      read -r str2 < <(sudo nix-collect-garbage -d 2>/dev/null | tail -n 1)

      sp1=$(echo "$str1" | awk -F' ' '{print $1}')
      sp2=$(echo "$str2" | awk -F' ' '{print $1}')
      mib1=$(echo "$str1" | awk -F' ' '{print $5}' | cut -f 1 -d'.')
      mib2=$(echo "$str2" | awk -F' ' '{print $5}' | cut -f 1 -d'.')

      echo "$((sp1+sp2)) store paths deleted, $((mib1+mib2)) MiB saved."
    }

    garbage_collect && exit 0
  '';
in {
  home.packages = [nix-clean];
}

