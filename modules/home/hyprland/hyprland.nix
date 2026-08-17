{ pkgs, ... }:
{
  home.packages = with pkgs; [
    swww
    grimblast
    hyprpicker
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland
    direnv
    tesseract
    hyprpolkitagent
    (pkgs.writeScriptBin "gparted" ''
      #!${pkgs.bash}/bin/bash
      exec pkexec env WAYLAND_DISPLAY="$WAYLAND_DISPLAY" \
                   XDG_RUNTIME_DIR="$XDG_RUNTIME_DIR" \
                   ${pkgs.gparted}/bin/gparted "$@"
    '')
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  
  wayland.windowManager.hyprland.settings.cursor = {
  no_hardware_cursors = true;
   };
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;       # using system package
    portalPackage = null;
    xwayland.enable = true;
    systemd.enable = true;
    configType = "hyprlang";

    settings = {
      monitor = [
        "monitor=DP-1,preferred,0x0,1"
        "monitor=HDMI-A-1,preferred,1920x0,1,transform,1"
        "monitor=DP-2,1920x1080@60,0x1080,1"
      ];

      exec-once = [
        "systemctl --user start hyprpolkitagent.service"
      ];
    };
  };
}
