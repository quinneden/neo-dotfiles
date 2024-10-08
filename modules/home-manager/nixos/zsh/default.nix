{
  pkgs,
  config,
  lib,
  ...
}: let
  aliases = {
    "bs" = "stat -c%s";
    "cddf" = "cd $dotdir";
    "cddl" = "cd ~/Downloads";
    "code" = "codium";
    "db" = "distrobox";
    "gst" = "git status";
    "gsur" = "git submodule update --init --recursive";
    "l" = "eza -la --group-directories-first";
    "ll" = "eza -glAh --octal-permissions --group-directories-first";
    "ls" = "eza -A";
    "tree" = "eza -ATL3 --git-ignore";
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
        custom = "${config.xdg.configHome}/zsh";
      };
      initExtra = ''
        zstyle ':completion:*' menu select
        bindkey "^[[1;5C" forward-word
        bindkey "^[[1;5D" backward-word
        unsetopt BEEP

        HISTFILE="$ZDOTDIR/.zsh_history"; export HISTFILE

        for f ($HOME/.config/zsh/functions/*(N.)); do source $f; done

        if type zoxide &>/dev/null; then eval "$(zoxide init zsh)"; fi
        if type z &>/dev/null; then alias cd='z'; fi

        if [[ $TERM_PROGRAM == 'vscode' ]]; then
          autoload -U promptinit; promptinit
          prompt pure
        fi
      '';
      initExtraBeforeCompInit = ''
        fpath+=("${config.xdg.configHome}/zsh/completions" "${pkgs.lix}/share/zsh/site-functions")
      '';
      sessionVariables = {
        compdir = "${config.xdg.configHome}/zsh/completions";
        dotdir = "/home/quinn/.dotfiles";
        EDITOR = "mi";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        MICRO_TRUECOLOR = "1";
        NIXOS_CONFIG = "$HOME/.dotfiles";
        PAGER = "bat --style=grid,numbers --wrap=never";
      };
    };

    bash = {
      enable = true;
      initExtra = "SHELL=${pkgs.bash}/bin/bash";
      shellAliases = aliases // config.shellAliases;
    };
  };
}
