{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "start-wallpaperengine" ''
      # Wrapper script to launch linux-wallpaperengine on Hyprland startup.
      # Logs everything to a file so we can debug exec-once failures.

      LOGFILE="$HOME/.cache/wallpaperengine.log"
      mkdir -p "$(dirname "$LOGFILE")"

      log() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
      }

      log "=== start-wallpaperengine invoked ==="
      log "Current user: $(whoami)"
      log "HOME: $HOME"
      log "WAYLAND_DISPLAY: $WAYLAND_DISPLAY"
      log "XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"

      # Give Hyprland / monitors time to fully initialize before launching.
      SLEEP_DELAY=8
      log "Sleeping for $SLEEP_DELAY seconds before launch..."
      sleep "$SLEEP_DELAY"

      # ---- CONFIGURE THESE ----
      ASSETS_DIR="/run/media/hashim/games/SteamLibrary/steamapps/common/wallpaper_engine/assets"

      DP1_WALLPAPER="/run/media/hashim/games/SteamLibrary/steamapps/workshop/content/431960/3370748890"
      DP2_WALLPAPER="/run/media/hashim/games/SteamLibrary/steamapps/workshop/content/431960/1086938607"
      HDMI1_WALLPAPER="/run/media/hashim/games/SteamLibrary/steamapps/workshop/content/431960/3004616560"
      # --------------------------

      log "Assets dir: $ASSETS_DIR"
      log "DP-1 wallpaper: $DP1_WALLPAPER"
      log "DP-2 wallpaper: $DP2_WALLPAPER"
      log "HDMI-A-1 wallpaper: $HDMI1_WALLPAPER"

      for p in "$ASSETS_DIR" "$DP1_WALLPAPER" "$DP2_WALLPAPER" "$HDMI1_WALLPAPER"; do
        if [ ! -d "$p" ]; then
          log "ERROR: Path does not exist: $p"
          exit 1
        fi
      done

      log "Launching linux-wallpaperengine for all 3 monitors..."
      ${pkgs.linux-wallpaperengine}/bin/linux-wallpaperengine \
        --assets-dir "$ASSETS_DIR" \
        --screen-root DP-1 --bg "$DP1_WALLPAPER" \
        --screen-root DP-2 --bg "$DP2_WALLPAPER" \
        --screen-root HDMI-A-1 --bg "$HDMI1_WALLPAPER" \
        >> "$LOGFILE" 2>&1 &

      PID=$!
      log "Launched with PID $PID"

      sleep 2
      if kill -0 "$PID" 2>/dev/null; then
        log "Process $PID still running after 2s — looks healthy."
      else
        log "ERROR: Process $PID died immediately. Check log above for errors."
      fi

      log "=== script finished ==="
    '')
  ];
}
