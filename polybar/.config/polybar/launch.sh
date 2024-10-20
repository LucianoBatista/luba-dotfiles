#!/usr/bin/env bash

# Terminate already running bar instances
# polybar-msg cmd quit
# or
killall -q polybar

# Launch bar1 and bar2
echo "---" | tee -a /tmp/polybar1.log
polybar mybar 2>&1 | tee -a /tmp/polybar1.log & disown

echo "Bars launched..."
