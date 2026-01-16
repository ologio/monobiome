#!/usr/bin/env bash
# note: this script is not portable; script to be placed in the monobiome
# scripts/ directory and run from the repo root (notice the `rm` invocations)

# clean existing config
rm -rf app-config/*

biomes=(alpine badlands chaparral savanna grassland tundra reef heathland moorland)
modes=(light dark)
lightness=(90 20)
rootdir="templates"

for biome in "${biomes[@]}"; do
  for i in "${!modes[@]}"; do
    mode=${modes[i]}
    light=${lightness[i]}

    # generate scheme file for biome/mode/lightness
    uv run monobiome scheme "${mode}" "${biome}" \
        -d 0.42 \
        -l "${light}" \
        -o scheme.toml

    # iterate over app config in "templates/"
    find "$rootdir" -type f -print0 |
    while IFS= read -r -d '' path; do
      subpath=${path#"$rootdir"/}
      dir=${subpath%/*}
      file=${subpath##*/}
      new_name=${biome}-monobiome-${mode}.${file}

      mkdir -p "app-config/${dir}"
      uv run monobiome fill scheme.toml "$path" \
          -p "colors/hex-palette.toml" \
          -o "app-config/${dir}/${new_name}"
    done
  done
done

# remove lingering scheme file
rm scheme.toml

cd app-config/firefox
shopt -s nullglob
for f in *; do
  [[ -f $f ]] || continue
  name=${f##*/}; name=${name%.*}
  bsdtar -cf "$name.xpi" --format zip -s ':^.*$:manifest.json:' -- "$f"
done

# consolidate firefox artifacts
rm *.*-manifest.json
rm *-light.*
perl-rename 's/^([^-.]+)-([^-.]+)-([^-.]+)\.([^-.]+)-manifest\.xpi/$1-$2-$4.xpi/' *
perl-rename 's/^([^-.]+)-([^-.]+)-auto\.xpi/$1-$2.xpi/' *
