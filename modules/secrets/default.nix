{config, inputs, pkgs, ...}: {
  age.secrets = {
    cachix = {
      nixos-asahi = {
        authtoken.file = ../../secrets/cachix/nixos-asahi/authtoken.age;
        pubkey.file = ../../secrets/cachix/nixos-asahi/pubkey.age;
        url.file = ../../secrets/cachix/nixos-asahi/url.age;
      };
      quinneden = {
        authtoken.file = ../../secrets/cachix/quinneden/authtoken.age;
        pubkey.file = ../../secrets/cachix/quinneden/pubkey.age;
        url.file = ../../secrets/cachix/quinneden/url.age;
      };
    };
    github = {
      authtoken.file = ../../secrets/github/authtoken.age;
      ghcr-authtoken.file = ../../secrets/github/ghcr-authtoken.age;
    };
    gitlab = {
      authtoken.file = ../../secrets/gitlab/authtoken.age;
    };
  };
}
