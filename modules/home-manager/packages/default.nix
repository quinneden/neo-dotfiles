{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ../../../packages
    ../../../scripts
  ];

  packages = with pkgs; {
    darwin = [
      aria2
      gawk
      gnutar
      xz
      zip
      zstd
    ];
    linux = [
      bat
      cmake
      direnv
      eza
      fd
      fzf
      gcc
      gh
      git-crypt
      glow
      gnumake
      gnupg
      gptfdisk
      gtrash
      jq
      nodejs
      openssl
      pass
      pkg-config
      pure-prompt
      python312
      rclone
      ripgrep
      rustc
      rustup
      vagrant
      vesktop
      xwaylandvideobridge
      zoxide
    ];
    cli = [
      cachix
      inputs.alejandra.defaultPackage.${system}
      inputs.nix-shell-scripts.packages.${system}.default
    ];
  };
}
