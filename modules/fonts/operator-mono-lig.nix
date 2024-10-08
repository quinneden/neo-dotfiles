{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "operator-mono-lig";
  version = "1.0";

  src = ../../assets/OperatorMonoLig.zip;

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
