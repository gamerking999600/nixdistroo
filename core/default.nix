{ ... }:
{
  imports = [
    ./nixpkgs.nix
    ./bootloader.nix
    ./hardware.nix
    ./xserver.nix
    ./network.nix
    ./nh.nix
    ./pipewire.nix
    ./program.nix
    ./security.nix
    ./services.nix
    ./snap.nix
    ./steam.nix
    ./system.nix
    ./flatpak.nix
    ./user.nix
    ./wayland.nix
    ./virtualization.nix
    ./qmk.nix
  ];
}
