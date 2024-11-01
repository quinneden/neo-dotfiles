{ pkgs, ... }:
{
  xdg.configFile."micro/bindings.json".text = ''
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

  xdg.configFile."micro/settings.json".text = ''
    {
      "autoclose": true,
      "autosu": true,
      "colorscheme": "cuddles",
      "comment": true,
      "diff": true,
      "ftoptions": true,
      "initlua": true,
      "linter": true,
      "literate": true,
      "pluginchannels": [],
      "pluginrepos": [
        "https://raw.githubusercontent.com/quinneden/micro-autofmt/refs/heads/main/repo.json"
      ],
      "parsecursor": true,
      "reload": "auto",
      "rmtrailingws": true,
      "saveundo": true,
      "tabhighlight": true,
      "tabsize": 2,
      "tabstospaces": true
    }
  '';
  xdg.configFile."micro/colorschemes/cuddles.micro".text = ''
    color-link default "#F8F8F2,#E0282828"
    color-link comment "#75715E,#282828"

    color-link identifier "#66D9EF,#282828"
    color-link identifier.var "cyan,#282828"
    color-link identifier.macro "cyan,#282828"

    color-link constant "#AE81FF,#282828"
    color-link constant.number "#9EB493,#282828"
    color-link constant.string "#E6DB74,#282828"
    color-link constant.string.char "#BDE6AD,#282828"

    color-link statement "#AF8EC5,#282828"
    color-link symbol.operator "#AF8EC5,#282828"
    color-link preproc "#CB4B16,#282828"
    color-link type "blue,#282828"
    color-link special "#A6E22E,#282828"
    color-link underlined "#D33682,#282828"
    color-link error "bold #CB4B16,#282828"
    color-link todo "bold #D33682,#282828"
    color-link statusline "#282828,#F8F8F2"
    color-link tabbar "#282828,#F8F8F2"
    color-link indent-char "#505050,#282828"
    color-link line-number "#AAAAAA,#323232"
    color-link current-line-number "#AAAAAA,#282828"
    color-link diff-added "#00AF00"
    color-link diff-modified "#FFAF00"
    color-link diff-deleted "#D70000"
    color-link gutter-error "#CB4B16,#282828"
    color-link gutter-warning "#E6DB74,#282828"
    color-link cursor-line "#323232"
    color-link color-column "#323232"

    color-link type.extended "default"
    #color-link symbol.brackets "default"
    color-link symbol.tag "#AE81FF,#282828"
  '';
}
