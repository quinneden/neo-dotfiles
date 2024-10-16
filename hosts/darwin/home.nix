{
  inputs,
  config,
  pkgs,
  ...
}:
{

  home.file.".hushlogin".text = "";

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "24.11";
}
