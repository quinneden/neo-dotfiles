{pkgs, ...}: let
  repos = pkgs.writeShellScriptBin "repos" ''
    repos() {
      if [[ $# -ge 1 ]]; then
        if [[ $1 =~ personal || $1 =~ hack-ons ]]; then
          subdir=""
        else
          subdir="personal/"
        fi
        subdir+="$1"
      fi

      if [[ -n $subdir ]]; then
        cd "$HOME/repos/$subdir"
      else
        cd "$HOME/repos"
      fi
    }
  '';
in {
  home.packages = [repos];

  xdg.configFile."zsh/completions/_repos".text = ''
    _repos() {
      _files -/ -W $HOME/repos/personal || _files -/ -W $HOME/repos/
    }
  '';
}
