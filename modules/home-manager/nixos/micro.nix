{
  pkgs,
  inputs,
  ...
}: {
  xdg.configFile = {
    "micro/bindings.json".text = ''
      {
        "\u001b[1;2A": "SelectUp",
        "\u001b[1;2B": "SelectDown",
        "\u001b[1;2C": "SelectRight",
        "\u001b[1;2D": "SelectLeft",
        "\u001b[1;3D": "WordLeft",
        "\u001b[1;3C": "WordRight",
        "\u001b[1;3A": "MoveLinesUp",
        "\u001b[1;3B": "MoveLinesDown",
        "\u001b[1;4C": "SelectWordRight",
        "\u001b[1;4D": "SelectWordLeft",
        "\u001b[1;5D": "StartOfLine",
        "\u001b[1;5C": "EndOfLine",
        "\u001b[1;6D": "SelectToStartOfLine",
        "\u001b[1;6C": "SelectToEndOfLine",
        "\u001b[1;5A": "CursorStart",
        "\u001b[1;5B": "CursorEnd",
        "\u001b[1;6A": "SelectToStart",
        "\u001b[1;6B": "SelectToEnd"
      }
    '';

    "micro/settings.json".text = ''
      {
        "autoclose": true,
        "autofmt.fmt-onsave": true,
        "autosu": true,
        "colorscheme": "dracula-tc",
        "comment": true,
        "diff": true,
        "ftoptions": true,
        "initlua": true,
        "linter": true,
        "literate": true,
        "pluginchannels": [
          "https://raw.githubusercontent.com/micro-editor/plugin-channel/master/channel.json"
        ],
        "parsecursor": true,
        "pluginrepos": [],
        "reload": "auto",
        "rmtrailingws": true,
        "saveundo": true,
        "tabhighlight": true,
        "tabsize": 2,
        "tabstospaces": true
      }
    '';
  };
}
