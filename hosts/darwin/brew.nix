{pkgs, ...}: {
  homebrew = {
    taps = [
      "homebrew/bundle"
      "homebrew/services"
    ];
    casks = [
      "betterdisplay"
      "docker"
      "eloston-chromium"
      "eqmac"
      "iterm2"
      "macfuse"
      "podman-desktop"
      "utm"
      "vagrant"
      "vscodium"
    ];
    brews = [
      "act"
      "automake"
      "awscli"
      "openssl@3"
      "sqlite"
      "aria2"
      "bat"
      "bison"
      "bzip2"
      "lzo"
      "cask"
      "chroma"
      "chruby"
      "cmake"
      "curl"
      "cython"
      "docker"
      "eza"
      "fd"
      "flex"
      "fzf"
      "gcc"
      "gh"
      "git"
      "git-crypt"
      "git-lfs"
      "glab"
      "glow"
      "gnu-sed"
      "gnupg"
      "go"
      "gum"
      "pkg-config"
      "gobject-introspection"
      "gptfdisk"
      "jq"
      "just"
      "ldid"
      "lftp"
      "libb2"
      "libffi"
      "libvirt"
      "lima"
      "llvm"
      "lzip"
      "make"
      "mas"
      "meson"
      "micro"
      "ncdu"
      "node"
      "p7zip"
      "pass"
      "perl"
      "pipenv"
      "pipx"
      "podman"
      "pure"
      "pv"
      "pyenv-virtualenv"
      "pygments"
      "qemu"
      "rbenv"
      "rclone"
      "ripgrep"
      "rsync"
      "ruby-install"
      "rust"
      "rustup"
      "shellcheck"
      "socket_vmnet"
      "trash"
      "tree"
      "w3m"
      "wget"
      "whalebrew"
      "yapf"
      "zlib"
      "zoxide"
    ];
    masApps = {
      "Adobe Lightroom" = 1451544217;
    };
  };
}
