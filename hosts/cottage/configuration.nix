{ inputs
, outputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "cottage";

  boot.bootspec.enable = true;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub = {
    enable = lib.mkForce false;
    efiSupport = true;
    device = "nodev"; # EFI only
    extraEntries = ''
      menuentry "Windows" {
        insmod fat
        insmod part_gpt
        insmod chain
        search --no-floppy --fs-uuid B458-8BFF --set root
        chainloader /EFI/Microsoft/Boot/bootmgfw.efi
      }
    '';
  };

  services.getty.autologinUser = "comfy";
  users.users.comfy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "input" "networkmanager" ];
    packages = with pkgs; [
      vim
    ];
  };

  environment.variables = {
    TERMINAL = "kitty";
  };
  environment.systemPackages = import ./system-packages.nix pkgs;

  services.flatpak.enable = true;

  system.stateVersion = "23.05";

  networking.wireless.networks.eduroam = {
    auth = ''
      key_mgmt=WPA-EAP
      eap=PWD
      identity="u603832@uvt.nl"
      password="F3bowenTU"
      '';
  };

  security.pam.services.swaylock = {};

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    opengl.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal ];
  };

  nixpkgs = {
    config.max-jobs = 5;
    config.enableParallelBuilding = true;
  };

  systemd.services."vtcol" = {
    script = "echo starting vtcol";
    wantedBy = [ "multi-user.target" ];
    after = [ "graphical.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = lib.mkForce ''
      /home/comfy/.hayashi/pack/bin/vtcol colors set --file /home/comfy/.vtcol/evergarden
      '';
    };
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && (
            action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions"
          )
        )
      {
        return polkit.Result.YES;
      }
    })
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.systemd1.manage-units") {
        if (action.lookup("unit") == "wpa_supplicant.service") {
          var verb = action.lookup("verb");
          if (verb == "start" || verb == "stop" || verb == "restart") {
              return polkit.Result.YES;
          }
        }
      }
    });
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.NetworkManager.*") {
        return polkit.Result.YES
      }
    });
    '';
}
