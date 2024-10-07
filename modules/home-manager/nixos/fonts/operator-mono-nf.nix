{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "operator-mono-nf";
  version = "1.0";

  src = ../../../assets/OperatorMonoNF.zip;

  unpackPhase = ''
    runHook preUnpack
    ${pkgs.unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 *.otf -t $out/share/fonts/opentype

    runHook postInstall
  '';
}
