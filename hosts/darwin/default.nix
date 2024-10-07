{
  config,
  inputs,
  dotDir,
  secrets,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./system.nix
    ../modules/darwin/brew.nix
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
      inherit inputs dotDir secrets;
    };
    users.quinn = import ./home.nix;
  };

  security.pam.enableSudoTouchIdAuth = true;

  nix.configureBuildUsers = true;
  #ids.uids.nixbld = lib.mkForce 40000;
  #ids.gids.nixbld = 30000;

  nix = {
    distributedBuilds = true;
    daemonProcessType = "Adaptive";
    settings = {
      accept-flake-config = true;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = ["nix-command" "flakes"];
      extra-substituters = [
        "${secrets.cachix.quinneden.url}"
        "${secrets.cachix.nixos-asahi.url}"
        "https://cache.lix.systems"
      ];
      # extra-trusted-substituters = config.nix.settings.extra-substituters;
      extra-trusted-public-keys = [
        "${secrets.cachix.quinneden.public-key}"
        "${secrets.cachix.nixos-asahi.public-key}"
        "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o="
      ];
      warn-dirty = false;
      extra-nix-path = "nixpkgs=flake:nixpkgs";
      trusted-users = ["quinn" "root"];
      access-tokens = ["github=${secrets.github.api}"];
    };

    # buildMachines = [
    #   {
    #     hostName = "lima-nix-builder";
    #     system = "aarch64-linux";
    #     maxJobs = 6;
    #     protocol = "ssh-ng";
    #     sshUser = "root";
    #     sshKey = "${config.users.users.quinn.home}/.lima/_config/user";
    #     supportedFeatures = ["benchmark" "big-parallel" "nixos-test" "kvm"];
    #   }
    # ];

    linux-builder = {
      enable = true;
      ephemeral = true;
      maxJobs = 6;
      config = ({pkgs, ...}: {
        nix = {
          package = pkgs.lix;
          settings = {
            max-jobs = 6;
            access-tokens = ["github=${secrets.github.api}"];
            extra-substituters = [
              "${secrets.cachix.quinneden.url}"
              "${secrets.cachix.nixos-asahi.url}"
              "https://cache.lix.systems"
            ];
            # extra-trusted-substituters = config.nix.settings.substituters;
            extra-trusted-public-keys = [
              "${secrets.cachix.quinneden.public-key}"
              "${secrets.cachix.nixos-asahi.public-key}"
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
      });
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
      extraFlags = ["--quiet"];
      upgrade = true;
    };
    global.brewfile = true;
    caskArgs.language = "en-US";
  };

  system.stateVersion = 5;
}
