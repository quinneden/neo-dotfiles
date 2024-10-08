let
  quinn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAC7zyuXln5BAbquqnOtfcEBoRq8YzoSaeJYfa3Lh5OY";
  root = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICLebu2z8cr5A2q7FzlVNcQrfM3fdYlD8O8lgTyruJoZ";
  users = [quinn root];

  macos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKmqEUgkxmYhlnLrgc+ygZ3DlhWUvUeRwdV1lBLkIRQk";
  nixos = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ9Ju24Suf9dQb7cz47pf07j51QYMeuQbJSz30SAK5x7";
  systems = [macos nixos];
in
{
  "secrets/cachix/nixos-asahi/authtoken.age".publicKeys = users ++ systems;
  "secrets/cachix/nixos-asahi/pubkey.age".publicKeys = users ++ systems;
  "secrets/cachix/nixos-asahi/url.age".publicKeys = users ++ systems;
  "secrets/cachix/quinneden/authtoken.age".publicKeys = users ++ systems;
  "secrets/cachix/quinneden/pubkey.age".publicKeys = users ++ systems;
  "secrets/cachix/quinneden/url.age".publicKeys = users ++ systems;
  "secrets/cachix/personal-authtoken.age".publicKeys = users ++ systems;
  "secrets/github/authtoken.age".publicKeys = users ++ systems;
  "secrets/github/ghcr-authtoken.age".publicKeys = users ++ systems;
  "secrets/gitlab/authtoken.age".publicKeys = users ++ systems;
  "secrets/cloudflare.age".publicKeys = users ++ systems;
}
