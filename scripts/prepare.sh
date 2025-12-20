#!/usr/bin/env bash
# usage: prepare.sh
# synopsis: prepare repo with generated assets

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# write palette files
mkdir -p colors
uv run monobiome palette -n hex -f toml -o colors/hex-palette.toml
uv run monobiome palette -n oklch -f toml -o colors/oklch-palette.toml

# generate provided app config
"$script_dir/generate.sh"
