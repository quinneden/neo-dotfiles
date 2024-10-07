{
  dotDir,
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = ".config/zsh";
    oh-my-zsh = {
      enable = true;
      custom = "${config.xdg.configHome}/zsh";
      plugins = ["direnv" "iterm2"];
    };
    shellAliases = {
      "alx.builds" = "curl -sL https://fedora-asahi-remix.org/builds | EXPERT=1 sh";
      "alx.dev" = "curl -sL https://alx.sh/dev | EXPERT=1 sh";
      "alx.sh" = "curl -sL https://alx.sh | EXPERT=1 sh";
      bs = "stat -f%z";
      cddl = "cd ~/Downloads";
      cddf = "cd ${dotDir}";
      code = "codium";
      code-flake = "cd ${dotDir} && codium .";
      df = "df -h";
      du = "du -h";
      flake-tree = "eza -aT ${dotDir} -I '.git*|.vscode*|*.DS_Store|Icon?'";
      gst = "git status";
      gsur = "git submodule update --init --recursive";
      l = "eza -la --group-directories-first";
      ll = "eza -glAh --octal-permissions --group-directories-first";
      ls = "eza -A";
      lsblk = "diskutil list";
      lsudo = "lima sudo";
      mi = "micro";
      push = "git push";
      py = "python";
      reboot = "sudo reboot";
      rf = "rm -rf";
      sed = "gsed";
      shutdown = "sudo shutdown -h now";
      surf = "sudo rm -rf";
      tree = "eza -aT -I '.git*'";
    };
    sessionVariables = {
      PAGER = "bat --style=grid,numbers --wrap=never";
      BAT_THEME = "Dracula";
      compdir = "${config.xdg.configHome}/zsh/completions";
      dotdir = "${dotDir}";
      EDITOR = "micro";
      EZA_ICON_SPACING = "2";
      LANG = "en_US.UTF-8";
      MICRO_TRUECOLOR = "1";
      TMPDIR = "/tmp";
      PATH = "/run/current-system/sw/bin:/etc/profiles/per-user/quinn/bin:/Users/quinn/.local/bin:\${PATH:+$PATH}";
    };
    initExtra = ''
      HISTFILE="$ZDOTDIR/.zsh_history"; export HISTFILE

      [[ $PATH =~ '/nix/store' ]] || eval $(/opt/homebrew/bin/brew shellenv)

      if type zoxide &>/dev/null; then eval "$(zoxide init zsh)"; fi
      if type z &>/dev/null; then alias cd='z'; fi

      fpath+=("${pkgs.lix}/share/zsh/site-functions" "/opt/homebrew/share/zsh/site-functions")

      autoload -Uz compinit && compinit

      for f (~/.config/zsh/functions/*(N.)); do source $f; done
    '';
  };
}
