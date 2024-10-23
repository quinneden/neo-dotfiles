{ pkgs, ... }:
{
  imports = [
    (import ../shared/xresources.nix { inherit colors; })

    #(import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    #(import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })

    (import ./conf/browsers/firefox/default.nix { inherit colors pkgs; })
    (import ./conf/browsers/brave/default.nix { inherit pkgs; })

    #(import ./conf/utils/sxhkd/default.nix { })
    #(import ./conf/utils/obs/default.nix { inherit pkgs; })
    #(import ./conf/utils/picom/default.nix { inherit colors pkgs inputs; })

    # Shell
    (import ./conf/shell/zsh/default.nix {
      inherit
        config
        colors
        pkgs
        lib
        ;
    })
    (import ./conf/shell/tmux/default.nix { inherit pkgs; })

    #(import ./conf/ui/hyprland/default.nix { inherit config pkgs lib inputs colors; })
    #(import ./conf/ui/swayfx/default.nix { inherit config pkgs lib colors inputs walltype; })
    #(import ./conf/ui/ags/default.nix { inherit pkgs inputs colors; })

    (import ./conf/term/wezterm/default.nix { inherit pkgs colors inputs; })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })

    #(import ./conf/editors/vscopium/default.nix { inherit pkgs colors; })

    # Music thingies
    (import ./conf/music/spicetify/default.nix { inherit colors inputs pkgs; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/hypr.nix { inherit config pkgs; })
    (import ./conf/music/cava/default.nix { inherit colors; })

    # Some file generation
    (import ./misc/vencord.nix { inherit config colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./misc/xinit.nix { inherit colors; })
    (import ./misc/ewwags.nix { inherit config colors; })
    (import ./misc/obsidian.nix { inherit colors; })

    # Bin files
    (import ../shared/bin/default.nix { inherit config colors walltype; })
  ];
}
