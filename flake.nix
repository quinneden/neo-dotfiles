{
  description = "NixOS & Nix-darwin configurations.";

  inputs = {
    ags.url = "github:Aylur/ags";
    alejandra = {
      url = "github:kamadorueda/alejandra";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";
    nixos-apple-silicon = {
      url = "github:tpwrules/nixos-apple-silicon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # WIP
    nur.url = "github:nix-community/NUR";
    nixpkgs-f2k.url = "github:moni-dz/nixpkgs-f2k";
    crystal = {
      url = "github:namishh/crystal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    darkmatter.url = "gitlab:VandalByte/darkmatter-grub-theme";

    matugen = {
      url = "github:/InioX/Matugen";
    };

    swayfx = {
      url = "github:/WillPower3309/swayfx";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swayhide.url = "github:/rehanzo/swayhide";
  };

  outputs =
    inputs@{
      home-manager,
      lix-module,
      nix-darwin,
      nixos-apple-silicon,
      nixpkgs,
      self,
      ...
    }:
    let
      dotdir = "$HOME/.dotfiles";
      secrets = builtins.fromJSON (builtins.readFile ./secrets/common.json);
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs
          [
            "aarch64-linux"
            "aarch64-darwin"
          ]
          (
            system:
            function (
              import nixpkgs {
                inherit system;
                config.allowUnfree = true;
              }
            )
          );
    in
    {
      formatter = forAllSystems (pkgs: pkgs.nixfmt-rfc-style);

      darwinConfigurations =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ lix-module.overlays.lixFromNixpkgs ];
          };
        in
        {
          "macos" = nix-darwin.lib.darwinSystem {
            inherit system pkgs;
            specialArgs = {
              inherit inputs dotdir secrets;
            };
            modules = [
              ./hosts/darwin
              lix-module.nixosModules.lixFromNixpkgs
            ];
          };
        };

      nixosConfigurations =
        let
          system = "aarch64-linux";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [
              nixos-apple-silicon.overlays.default
              inputs.crystal.overlays.default
            ];
          };
        in
        {
          "nixos" = nixpkgs.lib.nixosSystem {
            inherit pkgs system;
            specialArgs = {
              inherit
                inputs
                dotdir
                self
                secrets
                ;
            };
            modules = [
              ./hosts/nixos
              lix-module.nixosModules.default
              inputs.darkmatter.nixosModule
            ];
          };
        };
    };
}
