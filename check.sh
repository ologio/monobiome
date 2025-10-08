cd app-config/firefox
mkdir -p zips
shopt -s nullglob
for f in *; do
  [[ -f $f ]] || continue
  name=${f##*/}; name=${name%.*}
  bsdtar -cf "zips/$name.zip" --format zip -s ':^.*$:manifest.json:' -- "$f"
done

