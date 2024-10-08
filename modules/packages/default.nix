{
  config,
  pkgs,
  lib,
  ...
}: let
  micro-autofmt-nix = pkgs.callPackage ./micro-autofmt-nix.nix {};
in {
  config.xdg.configFile."micro/plug/micro-autofmt" = {
    source = micro-autofmt-nix;
    recursive = true;
  };

  options.packages = with lib; let
    packagesType = mkOption {
      type = types.listOf types.package;
      default = [];
    };
  in {
    linux = packagesType;
    darwin = packagesType;
    cli = packagesType;
  };

  config = {
    home.packages = with config.packages;
      if pkgs.stdenv.isDarwin
      then cli ++ darwin
      else cli ++ linux;
  };
}
