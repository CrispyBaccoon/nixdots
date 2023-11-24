let
  home = import <home-manager-config>;
in
{ pkgs, inputs, lib, config, ... }: {
  imports = [
    ./hyprland.nix
    ./dev.nix
    ./nvim.nix
    ./zsh.nix
    ./rust.nix
    ./spotify.nix
    ./vtcol.nix
  ];

  home.packages = with pkgs; [
    ranger
    starship

    pavucontrol

    nwg-look

    ncmpcpp
    cava
    mpv

    xfce.thunar

    unar
    unzip

    discord
  ];
}
