{pkgs, inputs, ...}: {
  imports = [
    ../packages
    ./scripts
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
      direnv
      nodejs
      vesktop
      rustup
      rustc
      gcc
      git-crypt
      glow
      gnumake
      gptfdisk
      cmake
      openssl
      pass
      pkg-config
      pure-prompt
      rclone
      zoxide
      vagrant
      python312
      gtrash
    ];
    cli = [
      bat
      cachix
      eza
      fd
      fzf
      gh
      gnupg
      ripgrep
      jq
      inputs.alejandra.defaultPackage.${system}
    ];
  };
}
