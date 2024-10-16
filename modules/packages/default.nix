{
  config,
  pkgs,
  lib,
  ...
}:
let
  micro-autofmt-nix = pkgs.callPackage ./micro-autofmt-nix.nix { };
in
{
  config.xdg.configFile."micro/plug/micro-autofmt" = {
    source = micro-autofmt-nix;
    recursive = true;
  };
}
