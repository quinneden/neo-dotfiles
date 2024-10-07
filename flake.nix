{
  description = "NixOS & Nix-darwin configurations.";

  inputs = {
    agenix.url = "github:ryantm/agenix";
    ags.url = "github:Aylur/ags";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs @ {
    agenix,
    home-manager,
    lix-module,
    nix-darwin,
    nixos-apple-silicon,
    nixpkgs,
    self,
    ...
  }: let
    # secrets = with inputs; builtins.fromJSON (builtins.readFile "${self}/secrets/secrets.json");
    secrets = with inputs; builtins.fromJSON (builtins.readFile "config.age.secrets.secrets.path");
    dotDir = "$HOME/.dotfiles";
    forAllSystems = function:
      nixpkgs.lib.genAttrs [
        "aarch64-linux"
        "aarch64-darwin"
      ] (system:
        function (import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }));
  in {
    formatter = forAllSystems (system: inputs.alejandra.defaultPackage.${system});

    packages.aarch64-linux.ags = nixpkgs.callPackage ./ags {inherit inputs;};

    darwinConfigurations = let
      system = "aarch64-darwin";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [lix-module.overlays.lixFromNixpkgs];
        config.allowUnfree = true;
      };
    in {
      "macos" = nix-darwin.lib.darwinSystem {
        inherit system pkgs;
        specialArgs = {inherit inputs dotDir secrets;};
        modules = [
          ./hosts/macmini/darwin
          home-manager.darwinModules.default
          {networking.hostName = "macos-macmini";}
        ];
      };
    };

    nixosConfigurations = let
      system = "aarch64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [nixos-apple-silicon.overlays.default];
      };
    in {
      "nixos" = nixpkgs.lib.nixosSystem {
        inherit pkgs system;
        specialArgs = {inherit inputs dotDir secrets self;};
        modules = [
          ./hosts/nixos
          agenix.nixosModules.default
          lix-module.nixosModules.lixFromNixpkgs
          nixos-apple-silicon.nixosModules.default
          home-manager.nixosModules.home-manager
          {
            networking.hostName = "nixos-macmini";
            age = {
              secrets.common.file = secrets/common.age;
              identityPaths = [ "/var/lib/persistent/ssh_host_ed25519_key" ];
            };
          }
        ];
      };
    };
  };
}







