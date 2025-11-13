#!/usr/bin/env bash
# usage: render.sh width height [extra kitty args...]
#   useful for reproducible screenshots of terminal/vim setups 

set -euo pipefail
w=${1:?width}; h=${2:?height}
out=${3:?file};
#out="kitty-$(date +%Y%m%d-%H%M%S).png"
shift 3 || true

# spawn a kitty window w/ a mark
title="kitty-$(date +%s%N)"
sock="$XDG_RUNTIME_DIR/kitty-$title.sock"
kitty -o allow_remote_control=yes --listen-on "unix:$sock" --title "$title" "$@" &

# create a targeted rule for the marked window and resize
sleep 2
swaymsg "for_window [title=\"$title\"] mark --add $title, floating enable, resize set width ${w} px height ${h} px, move position center" >/dev/null

# get the spawned window geometry
sleep 2
geom=$(swaymsg -t get_tree | jq -r --arg t "$title" '.. | select(.name? == $t) | .rect | "\(.x),\(.y) \(.width)x\(.height)"')
wgeom=$(swaymsg -t get_tree | jq -r --arg t "$title" '.. | select(.name? == $t) | .window_rect | "\(.x),\(.y) \(.width)x\(.height)"')

read gx gy _ < <(awk -F'[ ,x]' '{print $1,$2}' <<<"$geom")
read wx wy ww wh < <(awk -F'[ ,x]' '{print $1,$2,$3,$4}' <<<"$wgeom")
inner_geom="$((gx+wx)),$((gy+wy)) ${ww}x${wh}"

echo "+ title=$title"
echo "+ geom=$geom"
echo "+ out=$out"

# take a screenshot
mkdir -p "$(dirname "$out")"
grim -g "$inner_geom" "$out"
echo "saved: $out"

# close the kitty window
kitty @ --to "unix:$sock" close-window

