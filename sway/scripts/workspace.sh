#!/usr/bin/env bash
# Sway workspace navigation/moving without looping and with auto-creation

action=$1    # "workspace" or "move"
direction=$2 # "next" or "prev"

# Get current focused workspace number using python for robust JSON parsing
current_ws=$(swaymsg -r -t get_workspaces | python3 -c "import json, sys; print(next((w['num'] for w in json.load(sys.stdin) if w['focused']), 1))")

if [ "$direction" = "next" ]; then
    target=$((current_ws + 1))
elif [ "$direction" = "prev" ]; then
    if [ "$current_ws" -gt 1 ]; then
        target=$((current_ws - 1))
    else
        exit 0
    fi
fi

if [ "$action" = "move" ]; then
    swaymsg move container to workspace number "$target"
    swaymsg workspace number "$target"
else
    swaymsg workspace number "$target"
fi
