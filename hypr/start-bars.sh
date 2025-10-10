#!/usr/bin/env bash
set -euo pipefail

# Ensure eww is running
eww daemon || true

open_for_monitor() {
  case "$1" in
    eDP-1)    eww close bar1 2>/dev/null || true; eww open bar1 ;;
    HDMI-A-1) eww close bar2 2>/dev/null || true; eww open bar2 ;;
  esac
}

close_for_monitor() {
  case "$1" in
    eDP-1)    eww close bar1 2>/dev/null || true ;;
    HDMI-A-1) eww close bar2 2>/dev/null || true ;;
  esac
}

# Open bars for all currently connected monitors
for mon in $(hyprctl -j monitors | jq -r '.[].name'); do
  open_for_monitor "$mon"
done

# Watch Hyprland events and react to (re)connections/disconnections
hyprctl -m events | while IFS= read -r ev; do
  case "$ev" in
    monitoradded* )
      mon="${ev#monitoradded>>}"
      open_for_monitor "$mon"
      ;;
    monitorremoved* )
      mon="${ev#monitorremoved>>}"
      close_for_monitor "$mon"
      ;;
  esac
done
