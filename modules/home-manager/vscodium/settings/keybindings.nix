let
  keybindings = [
    {
      key = "ctrl+/";
      command = "editor.action.commentLine";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+shift+/";
      command = "editor.action.blockComment";
      when = "editorTextFocus && !editorReadonly";
    }
    {
      key = "ctrl+s";
      command = "workbench.action.files.saveFiles";
    }
    {
      key = "meta+s";
      command = "workbench.action.files.saveFiles";
    }
    {
      key = "meta+shift+w";
      command = "workbench.action.terminal.toggleTerminal";
      when = "terminal.active";
    }
    {
      key = "ctrl+w";
      command = "";
    }
    {
      key = "ctrl+d";
      command = "editor.action.duplicateSelection";
    }
    {
      key = "meta+shift+e";
      command = "workbench.view.explorer";
      when = "viewContainer.workbench.view.explorer.enabled";
    }
    {
      key = "meta+shift+f";
      command = "workbench.action.findInFiles";
    }
    {
      key = "alt+left";
      command = "workbench.action.focusPreviousGroup";
    }
    {
      key = "alt+right";
      command = "workbench.action.focusNextGroup";
    }
  ];
in
[ ] ++ keybindings
