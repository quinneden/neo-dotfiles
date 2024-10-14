{
  pkgs,
  config,
  ...
}:
{
  imports = [ ./distrobox-module.nix ];

  programs.distrobox = {
    enable = true;

    boxes =
      let
        exec = "${pkgs.zsh}/bin/zsh";
        symlinks = [
          ".bashrc"
          ".zshenv"
          ".config/nix"
          ".config/zsh"
          ".config/starship.toml"
        ];
        packages = config.packages.cli ++ [
          pkgs.nix
          pkgs.git
          pkgs.zsh
          pkgs.micro
          pkgs.eza
        ];
      in
      {
        Alpine = {
          inherit exec symlinks;
          img = "docker.io/library/alpine:latest";
        };
        Fedora = {
          inherit exec symlinks;
          packages = "nodejs npm poetry gcc mysql-devel python3-devel wl-clipboard";
          img = "registry.fedoraproject.org/fedora-toolbox:rawhide";
          nixPackages = packages ++ [
            (pkgs.writeShellScriptBin "pr" "poetry run $@")
            (pkgs.writeShellScriptBin "prpm" "poetry run python manage.py $@")
          ];
        };
        Arch = {
          inherit exec symlinks;
          img = "docker.io/library/archlinux:latest";
          packages = "base-devel wl-clipboard";
          nixPackages = packages ++ [
            (pkgs.writeShellScriptBin "yay" ''
              if [[ ! -f /bin/yay ]]; then
                tmpdir="$HOME/.yay-bin"
                if [[ -d "$tmpdir" ]]; then sudo rm -r "$tmpdir"; fi
                git clone https://aur.archlinux.org/yay-bin.git "$tmpdir"
                cd "$tmpdir"
                makepkg -si
                sudo rm -r "$tmpdir"
              fi
              /bin/yay $@
            '')
          ];
        };
      };
  };
}
