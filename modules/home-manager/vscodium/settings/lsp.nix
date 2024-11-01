{
  lib,
  pkgs,
}: {
  "black-formatter.path" = [(lib.getExe pkgs.black)];
  "stylua.styluaPath" = lib.getExe pkgs.stylua;
  "Lua.misc.executablePath" = "${pkgs.sumneko-lua-language-server}/bin/lua-language-server";
  "nix.enableLanguageServer" = true;
  "nix.serverPath" = lib.getExe pkgs.nil;
  "nix.formatterPath" = lib.getExe pkgs.nixfmt-rfc-style;
  "nix.serverSettings" = {
    "nil" = {
      "formatting" = {
        "command" = ["nixfmt"];
      };
      "diagnostics" = {
        "ignored" = ["unused_binding"];
      };
    };
  };
  "zig.path" = lib.getExe pkgs.zig;
  "zig.initialSetupDone" = true;
  "zig.zls.path" = lib.getExe pkgs.zls;
  "[lua]"."editor.defaultFormatter" = "JohnnyMorganz.stylua";
}
