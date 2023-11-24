{ home, lib, comfy_lib, pkgs, config, ... }: {
  systemd.user.services = {
    cliphist = comfy_lib.mkGraphicalService {
      Unit.Description = "Clipboard history service";
      Service = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --watch ${lib.getExe pkgs.cliphist} store";
        Restart = "always";
      };
    };
  };
  systemd.user.services = {
    dunst = comfy_lib.mkGraphicalService {
      Unit.Description = "Notification Daemon";
      Service = {
        ExecStart = "${pkgs.dunst}/bin/dunst";
        Restart = "always";
      };
    };
  };
  systemd.user.services = {
    swww = comfy_lib.mkGraphicalService {
      Unit.Description = "Wallpaper Daemon";
      Service = {
        ExecStart = "${pkgs.swww}/bin/swww-daemon";
        # Restart = "always";
      };
    };
    wallctl = comfy_lib.mkGraphicalService {
      Unit.Description = "Wallpaper cli";
      Unit.Path = [ pkgs.bash ];
      Service = {
        ExecStart = "${config.home.homeDirectory}/.local/share/wallctl/.wallpaperset";
        Restart = "never";
        RemainAfterExit = true;
        Type = "oneshot";
      };
    };
  };
  systemd.user.services = {
    wlsunset = comfy_lib.mkGraphicalService {
      Unit.Description = "";
      Service = {
        ExecStart = "${pkgs.wlsunset}/bin/wlsunset -t 5200 -S 09:00 -s 19:30";
        Restart = "always";
      };
    };
  };
  systemd.user.services = {
    batterynotify = comfy_lib.mkGraphicalService {
      Unit.Description = "";
      Service = {
        ExecStart = "${pkgs.bash}/bin/bash -c '${config.home.homeDirectory}/.config/hypr/scripts/batterynotify.sh'";
        Restart = "always";
      };
    };
  };
  systemd.user.services = {
    libinput-gestures = comfy_lib.mkGraphicalService {
      Unit.Description = "Touchpad gestures for wayland";
      Service = {
        ExecStart = "${pkgs.libinput-gestures}/bin/libinput-gestures -c ${config.home.homeDirectory}/.config/hypr/libinput-gestures.conf";
        Restart = "always";
      };
    };
  };
}
