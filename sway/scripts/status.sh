#!/usr/bin/env bash

# Colors
COLOR_TEXT="#f202be"
COLOR_BG="#fe85e4"

echo '{ "version": 1 }'
echo '['
echo '[]'

while true; do
  # Clock
  TIME=$(date +'%H:%M')
  
  # Battery
  if [ -d /sys/class/power_supply/BAT0 ]; then
    BATT=$(cat /sys/class/power_supply/BAT0/capacity)
    BATT_ICON=""
    if [ "$BATT" -le 20 ]; then BATT_ICON=""; fi
    BATT_STR="$BATT_ICON $BATT%"
  else
    BATT_STR=""
  fi
  
  # Volume
  VOL_INFO=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
  if [ $? -eq 0 ]; then
    VOL=$(echo "$VOL_INFO" | awk '{print int($2 * 100)}')
    MUTED=$(echo "$VOL_INFO" | grep -c "MUTED")
    VOL_ICON=""
    if [ "$MUTED" -eq 1 ]; then VOL_ICON=""; VOL_STR="$VOL_ICON muted"; else VOL_STR="$VOL_ICON $VOL%"; fi
  else
    VOL_STR=""
  fi

  # Helper to add "padding" using spaces
  container() {
    local text="  $1  " # Added 2 spaces on each side for padding
    echo "{\"full_text\": \"$text\", \"color\": \"$COLOR_TEXT\", \"background\": \"$COLOR_BG\", \"separator\": false, \"separator_block_width\": 10}"
  }

  # Output JSON
  JSON="["
  JSON+=$(container " $TIME")
  if [ -n "$VOL_STR" ]; then
    JSON+=","$(container "$VOL_STR")
  fi
  if [ -n "$BATT_STR" ]; then
    JSON+=","$(container "$BATT_STR")
  fi
  JSON+="]"
  
  echo ",$JSON"
  sleep 2
done
