{
  pkgs,
  inputs,
  config,
  ...
}: let
  commit-status = pkgs.fetchurl {
    url = "https://gist.github.com/quinneden/378834a3a54dec450b5462935a78a462/raw/5e4c64051e181b62d2f4128c863a5c468ccb1bdc/git-commit-status";
    hash = "sha256-MU3ZRba7Bdkjf7Ao03tzULVSD48Pe4DLRNO7bEe8cTY=";
  };
in {
  programs.git = {
    enable = true;
    extraConfig = {
      color.ui = true;
      core.editor = "micro";
      credential.helper = "store";
      github.user = "quinneden";
      push.autoSetupRemote = true;
      init.defaultBranch = "main";
      url."https://oauth2:${secrets.github.api}@github.com".insteadOf = "https://github.com";
      include.path = "${commit-status}";
    };
    userEmail = "quinnyxboy@gmail.com";
    userName = "Quinn Edenfield";
  };
}
