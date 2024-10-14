{ pkgs, ... }:
let
  FishTank = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/dexpota/kitty-themes/master/themes/fishtank.conf";
    hash = "";
  };
in
{
  programs.kitty = {
    enable = true;
    font = {
      size = 13;
      name = "Operator Mono Lig Book";
    };

    settings = {
      shell = "${pkgs.tmux}/bin/tmux";
      cursor_shape = "beam";
      scrollback_lines = 10000;
      placement_strategy = "center";

      allow_remote_control = "yes";
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";

      copy_on_select = "clipboard";

      window_padding_width = "6";
      confirm_os_window_close = "2";

      # colors
      background_opacity = "0.9";
    };

    theme = "Hardcore";
  };
}
