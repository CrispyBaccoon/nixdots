{ home, lib, comfy_lib, pkgs, config, ... }: {
  imports = [
    ./sound.nix
    ./hyprland.nix
    ./dunst
  ];
}
