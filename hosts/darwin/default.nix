{
  config,
  dotdir,
  inputs,
  lib,
  pkgs,
  secrets,
  ...
}:
{
  imports = [
    ./brew.nix
    ./system.nix
    ../../modules/fonts
    inputs.home-manager.darwinModules.default
  ];

  users.users.quinn = {
    description = "Quinn Edenfield";
    home = "/Users/quinn";
    shell = "/bin/zsh";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs dotdir secrets;
    };
    users.quinn.imports = [
      inputs.mac-app-util.homeManagerModules.default
      ./home.nix
      ../../modules/home-manager/extra/micro.nix
      ../../modules/home-manager/git
      ../../modules/home-manager/packages
      ../../modules/home-manager/vscodium
      ../../modules/home-manager/zsh
    ];
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix = {
    configureBuildUsers = true;
    distributedBuilds = true;
    daemonProcessType = "Adaptive";
    settings = {
      accept-flake-config = true;
      access-tokens = [ "github=${secrets.github.api}" ];
      builders-use-substitutes = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      # extra-substituters = [
      #   "${secrets.cachix.quinneden.url}"
      #   "https://cache.lix.systems"
      # ];
      # extra-trusted-public-keys = [
      #   "${secrets.cachix.quinneden.public-key}"
      #   "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      # ];
      trusted-users = [
        "quinn"
        "root"
      ];
      warn-dirty = false;
    };

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 6;
      config =
        { pkgs, ... }:
        {
          nix = {
            package = pkgs.lix;
            settings = {
              max-jobs = 6;
              access-tokens = [ "github=${secrets.github.api}" ];
              extra-substituters = [
                #   "${secrets.cachix.quinneden.url}"
                #   "${secrets.cachix.nixos-asahi.url}"
                "https://cache.lix.systems"
              ];
              extra-trusted-public-keys = [
                # "${secrets.cachix.quinneden.public-key}"
                # "${secrets.cachix.nixos-asahi.public-key}"
                "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
              ];
            };
          };
          virtualisation = {
            cores = 6;
            darwin-builder = {
              diskSize = 100 * 1024;
              memorySize = 6 * 1024;
            };
          };
        };
    };
  };

  services = {
    activate-system.enable = true;
    nix-daemon.enable = true;
  };

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--quiet" ];
      upgrade = true;
    };
    global.brewfile = true;
    caskArgs.language = "en-US";
  };

  system.stateVersion = 5;
}
