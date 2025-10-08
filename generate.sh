rm -rf app-config/*
symconf -c templates/ generate -o app-config

cd app-config/firefox
shopt -s nullglob
for f in *; do
  [[ -f $f ]] || continue
  name=${f##*/}; name=${name%.*}
  bsdtar -cf "$name.xpi" --format zip -s ':^.*$:manifest.json:' -- "$f"
done

# consolidate firefox artifacts
rm *.manifest.json
rm hard-* soft-*
rm *-light.*
perl-rename 's/^([^-.]+)-([^-.]+)-([^-.]+)-([^-.]+)\..*\.xpi/$2-$3.xpi/' *

