let
  home = import <home-manager-config>;
in
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  nix-colors,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true;
    extraConfig = ''
      source = ~/.config/hypr/hypr.conf
      '';
    plugins = [
      # inputs.hyprgrass.packages.${pkgs.system}.default
    ];
  };

  home.packages = with pkgs; [
    waybar
    rofi-wayland
    swww

    wl-clipboard
    cliphist
    wlsunset
    libnotify
    dunst
    wlogout

    inputs.hyprland-contrib.packages.${pkgs.system}.hyprprop

    grim
    slurp

    libinput-gestures
  ];

  home.file.".config/hypr/themes/nix.conf" =
    let
      colors = config.colorScheme.colors;
    in
  {
    enable = true;
    text = ''
      # configured from nix
      general {
        col.active_border = 0xff${colors.base02}
        col.inactive_border = 0xff${colors.base08}
      }
    '';
  };

  home.file.".config/hypr/libinput-gestures.conf" = {
    enable = true;
    text = ''
      gesture swipe up 3 ${pkgs.hyprland}/bin/hyprctl dispatch togglespecialworkspace
      '';
  };
}
