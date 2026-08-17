{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "fix-monitor-audio" ''
      LOGFILE="$HOME/.cache/monitor-audio.log"
      mkdir -p "$(dirname "$LOGFILE")"

      log() {
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOGFILE"
      }

      log "=== fix-monitor-audio invoked ==="

      # Give PipeWire/WirePlumber time to enumerate ALSA devices.
      SLEEP_DELAY=6
      log "Sleeping for $SLEEP_DELAY seconds before applying audio config..."
      sleep "$SLEEP_DELAY"

      CARD="alsa_card.pci-0000_01_00.1"
      PROFILE="output:hdmi-stereo"
      SINK="alsa_output.pci-0000_01_00.1.hdmi-stereo"

      log "Setting card profile: $CARD -> $PROFILE"
      ${pkgs.pulseaudio}/bin/pactl set-card-profile "$CARD" "$PROFILE" >> "$LOGFILE" 2>&1

      sleep 1

      log "Setting default sink: $SINK"
      ${pkgs.pulseaudio}/bin/pactl set-default-sink "$SINK" >> "$LOGFILE" 2>&1

      log "Setting volume to 80%"
      ${pkgs.wireplumber}/bin/wpctl set-volume "@DEFAULT_SINK@" 80% >> "$LOGFILE" 2>&1

      log "Current sinks:"
      ${pkgs.pulseaudio}/bin/pactl list short sinks >> "$LOGFILE" 2>&1

      log "=== fix-monitor-audio finished ==="
    '')
  ];
}
