{
  description = "NixOS & Nix-darwin configurations.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    lix-module.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";

    nixos-asahi = {
      url = "github:zzywysm/nixos-asahi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };

    matugen.url = "github:InioX/matugen";
    ags.url = "github:Aylur/ags";
    astal.url = "github:Aylur/astal";

    lf-icons = {
      url = "github:gokcehan/lf";
      flake = false;
    };

    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

    nix-shell-scripts.url = "github:quinneden/nix-shell-scripts";

    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    inputs@{
      home-manager,
      nix-darwin,
      nixpkgs,
      self,
      ...
    }:
    let
      secrets = builtins.fromJSON (builtins.readFile .secrets/common.json);
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

      packages.aarch64-linux.default = nixpkgs.legacyPackages.aarch64-linux.callPackage ./ags {
        inherit inputs;
      };

      darwinConfigurations =
        let
          system = "aarch64-darwin";
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = [ inputs.lix-module.overlays.lixFromNixpkgs ];
          };
        in
        {
          "macos" = nix-darwin.lib.darwinSystem {
            inherit system pkgs;
            specialArgs = {
              inherit inputs secrets;
              dotdir = "$HOME/.dotfiles";
            };
            modules = [
              ./hosts/darwin
              inputs.lix-module.nixosModules.lixFromNixpkgs
              inputs.mac-app-util.darwinModules.default
            ];
          };
        };

      nixosConfigurations = {
        nixos-macmini = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit inputs secrets;
            asztal = self.packages.aarch64-linux.default;
          };
          modules = [
            ./nixos/nixos.nix
            home-manager.nixosModules.home-manager
            inputs.lix-module.nixosModules.default
            inputs.nixos-asahi.nixosModules.default
            { networking.hostName = "nixos-macmini"; }
          ];
        };
      };

      # nixosConfigurations =
      #   let
      #     system = "aarch64-linux";
      #     pkgs = import nixpkgs {
      #       inherit system;
      #       config.allowUnfree = true;
      #       overlays = [ inputs.nixos-asahi.overlays.default ];
      #     };
      #   in
      #   {
      #     "nixos" = nixpkgs.lib.nixosSystem {
      #       inherit pkgs system;
      #       specialArgs = {
      #         inherit
      #           inputs
      #           dotdir
      #           self
      #           secrets
      #           ;
      #       };
      #       modules = [
      #         ./hosts/nixos
      #         lix-module.nixosModules.default
      #       ];
      #     };
      #   };
    };
}
