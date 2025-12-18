#!/usr/bin/env bash
# usage: screens.sh prefix

set -euo pipefail
prefix=${1:-}

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
render_script="$script_dir/render.sh"

biomes=(alpine) # badlands chaparral savanna grassland tundra reef heathland moorland)
modes=(dark)
distances=(0.3 0.4 0.5)

for biome in "${biomes[@]}"; do
    for mode in "${modes[@]}"; do
        for dist in "${distances[@]}"; do
            echo "Applying $biome-$mode theme"
            monobiome scheme "$mode" "$biome" \
                -d "$dist" \
                -l 20 \
                -o ~/.config/symconf/groups/theme/monobiome-none.toml
            symconf config \
                -a kitty,nvim \
                -m "$mode" \
                -s monobiome \
                -T font=Berkeley
            sleep 1

            echo "Taking screenshot..."
            "$render_script" 1920 1440 "images/render/$prefix-$biome-$mode-d$dist.png" nvim \
                +':highlight Cursor blend=100' \
                +':set guicursor=n:block-Cursor' \
                +':silent! setlocal nonumber nocursorline signcolumn=no foldcolumn=no' \
                +':lua vim.diagnostic.config({virtual_text=false,signs=false,underline=false})' \
                examples/class.py
        done
    done
done
