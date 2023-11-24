{ inputs
, outputs
, lib
, config
, pkgs
, nix-colors
, ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default

    inputs.hyprland.homeManagerModules.default

    ./system
    ./colors
    ./programs
    ./services
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.unstable-packages

      inputs.neovim-nightly-overlay.overlay
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  home = {
    username = "comfy";
    homeDirectory = "/home/comfy";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # gtk fix
  home.packages = [ pkgs.dconf ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
