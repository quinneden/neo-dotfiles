{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "db" = "distrobox";
    "cddf" = "cd $dotdir";
    "code" = "codium";
    "py" = "python";
    "rf" = "rm -rf";
    "tree" = "eza --icons --tree --group-directories-first -I '.git*'";
    "flake-update" = "sudo nix flake update ~/.dotfiles";
    "gst" = "git status";
    "gsw" = "git switch -c";
    "gb" = "git branch";
    "gch" = "git checkout";
    "ga" = "git add";
    "gr" = "git reset --soft HEAD~1";
  };
in {
  options.shellAliases = with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = {};
    };

  config.programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      shellAliases = aliases // config.shellAliases;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["fzf" "eza" "zoxide" "direnv"];
      };
      initExtra = ''
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        unsetopt BEEP

        for f (${config.xdg.configHome}/zsh/{functions,completions}/*(N.)); do source $f; done

        [[ $(type -w z) == 'z: function' ]] && alias cd='z' || true

        # if [[ $TERM_PROGRAM == 'vscode' ]]; then
        #   autoload -U promptinit; promptinit
        #   prompt pure
        # fi
      '';
      initExtraBeforeCompInit = ''
        fpath+=(${config.xdg.configHome}/zsh/completions)
      '';
      sessionVariables = {
        LC_ALL = "en_US.UTF-8";
        dotdir = "/home/quinn/.dotfiles";
        EDITOR = "mi";
      };
    };

    bash = {
      shellAliases = aliases // config.shellAliases;
      enable = true;
      initExtra = "SHELL=${pkgs.bash}/bin/bash";
    };
  };
}
