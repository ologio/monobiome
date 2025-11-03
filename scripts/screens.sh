#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
render_script="$script_dir/render.sh"

biomes=(alpine badlands chaparral savanna grassland tundra)
modes=(light dark)

for biome in "${biomes[@]}"; do
    for mode in "${modes[@]}"; do
        symconf config -m "$mode" -s "default-$biome-monobiome"
        sleep 5
        "$render_script" 800 600 nvim \
            +':highlight Cursor blend=100' \
            +':set guicursor=n:block-Cursor' \
            +':silent! setlocal nonumber nocursorline signcolumn=no foldcolumn=no' \
            examples/runner.py
