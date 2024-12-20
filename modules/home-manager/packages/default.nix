{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./packages-module.nix
  ];

  packages = with pkgs; {
    darwin = [
      aria2
      gawk
      gnutar
      xz
      zip
      zstd
      nil
    ];
    linux = [
      bat
      cmake
      direnv
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
    ];
    cli = [
      cachix
      eza
      inputs.alejandra.defaultPackage.${system}
      nixfmt-rfc-style
      inputs.nix-shell-scripts.packages.${system}.default
      zoxide
    ];
  };
}
