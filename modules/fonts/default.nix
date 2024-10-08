{
  pkgs,
  inputs,
  ...
}: let
  operator-mono-lig = pkgs.callPackage ./operator-mono-lig.nix {inherit pkgs;};
  operator-mono-nf = pkgs.callPackage ./operator-mono-nf.nix {inherit pkgs;};
in {
  fonts = {
    packages = with pkgs; [
      operator-mono-lig
      operator-mono-nf
      source-code-pro
      noto-fonts
      noto-fonts-cjk
      font-awesome
      (nerdfonts.override {
        fonts = [
          "NerdFontsSymbolsOnly"
          "CascadiaCode"
          "Hack"
          "FiraCode"
          "VictorMono"
          "Iosevka"
        ];
      })
    ];
    fontconfig = {
      enable = true;
      hinting.autohint = true;
    };
  };
}

