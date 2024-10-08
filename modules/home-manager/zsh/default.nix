{
  pkgs,
  config,
  lib,
  ...
}: let
  aliasesCommon = {
    "cddf" = "cd $dotdir";
    "cddl" = "cd ~/Downloads";
    "gst" = "git status";
    "gsur" = "git submodule update --init --recursive";
    "l" = "eza -la --group-directories-first";
    "ll" = "eza -glAh --octal-permissions --group-directories-first";
    "ls" = "eza -A";
    "push" = "git push";
    "tree" = "eza -ATL3 --git-ignore";
  };
  aliasesForLinux = {
    "bs" = "stat -c%s";
    "code" = "codium";
    "db" = "distrobox";
  };
  aliasesForDarwin = {
    "alx.builds" = "curl -sL https://fedora-asahi-remix.org/builds | EXPERT=1 sh";
    "alx.dev" = "curl -sL https://alx.sh/dev | EXPERT=1 sh";
    "alx.sh" = "curl -sL https://alx.sh | EXPERT=1 sh";
    "bs" = "stat -f%z";
    "lsblk" = "diskutil list";
    "reboot" = "sudo reboot";
    "sed" = "gsed";
    "shutdown" = "sudo shutdown -h now";
  };
in {
  imports = [./starship.nix];

  options.shellAliases = with lib;
    mkOption {
      type = types.attrsOf types.str;
      default = {};
    };

  config.programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh";
      shellAliases =
        (
          if pkgs.stdenv.isDarwin
          then aliasesForDarwin
          else aliasesForLinux
        )
        ++ aliasesCommon
        // config.shellAliases;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = ["fzf" "eza" "zoxide" "direnv"];
        custom = "${config.xdg.configHome}/zsh";
      };
      initExtraBeforeCompInit =
        lib.mkMerge (mkIf pkgs.stdenv.isDarwin ''
          fpath+=("/opt/homebrew/share/zsh/site-functions")
        '')
        ++ ''
          fpath+=("${pkgs.lix}/share/zsh/site-functions" "/opt/homebrew/share/zsh/site-functions" "${config.xdg.configHome}/zsh/completions")
        '';
      initExtra =
        lib.mkMerge (mkIf pkgs.stdenv.isDarwin ''
          [[ $PATH =~ '/nix/store' ]] || eval $(/opt/homebrew/bin/brew shellenv)
        '')
        ++ ''
          HISTFILE="$ZDOTDIR/.zsh_history"; export HISTFILE

          if type zoxide &>/dev/null; then eval "$(zoxide init zsh)"; fi
          if type z &>/dev/null; then alias cd='z'; fi

          for f ($HOME/.config/zsh/functions/*(N.)); do source $f; done

          if [[ $TERM_PROGRAM == 'vscode' ]]; then
            autoload -U promptinit; promptinit
            prompt pure
          fi
        '';
      sessionVariables = {
        compdir = "$HOME/.config/zsh/completions";
        dotdir = "$HOME/.dotfiles";
        EDITOR = "mi";
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
        MICRO_TRUECOLOR = "1";
        NIXOS_CONFIG = mkIf pkgs.stdenv.isLinux "$HOME/.dotfiles";
        PAGER = "bat --style=grid,numbers --wrap=never";
        TMPDIR = mkIf pkgs.stdenv.isDarwin "/tmp";
        PATH = mkIf pkgs.stdenv.isDarwin "/run/current-system/sw/bin:/etc/profiles/per-user/quinn/bin:/Users/quinn/.local/bin:\${PATH:+$PATH}";
      };
    };

    bash = {
      enable = true;
      initExtra = "SHELL=${pkgs.bash}/bin/bash";
      shellAliases =
        (
          if pkgs.stdenv.isDarwin
          then aliasesForDarwin
          else aliasesForLinux
        )
        ++ aliasesCommon
        // config.shellAliases;
    };
  };
}
