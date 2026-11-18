#!/bin/sh
# Checks every diagram, then writes dist/<name>.html = styles + only the icons
# that diagram uses + the diagram. Each dist file is one self-contained paste
# for the Confluence HTML macro.
set -eu
cd "$(dirname "$0")"

ids() { grep -oh "$1" "$2" | sed 's/.*[#"]//' | sort -u; }
defined=$(ids 'symbol id="dd-i-[a-z0-9-]*' library.html)
shown=$(ids 'href="#dd-i-[a-z0-9-]*' diagrams/catalog.html)

fail=0
for i in $defined; do
  echo "$shown" | grep -qx "$i" || { echo "icon missing from diagrams/catalog.html: $i"; fail=1; }
done
for f in diagrams/*.html; do
  for i in $(ids 'href="#dd-i-[a-z0-9-]*' "$f"); do
    echo "$defined" | grep -qx "$i" || { echo "$f: undefined icon $i"; fail=1; }
  done
  # every diagram root needs a text description for screen readers
  if grep -n '<div class="dd[ "]' "$f" | grep -v 'role="img" aria-label="[^"]'; then
    echo "$f: the lines above need role=\"img\" aria-label=\"...\""; fail=1
  fi
done
[ "$fail" = 0 ] || exit 1

rm -rf dist && mkdir dist
for f in diagrams/*.html; do
  used=" $(ids 'href="#dd-i-[a-z0-9-]*' "$f" | tr '\n' ' ')"
  awk -v used="$used" '
    /<symbol id="dd-i-/ { id = $0; sub(/.*<symbol id="/, "", id); sub(/".*/, "", id); if (!index(used, " " id " ")) next }
    { print }' library.html > "dist/$(basename "$f")"
  cat "$f" >> "dist/$(basename "$f")"
done
echo "built $(ls dist | wc -l | tr -d ' ') files in dist/"
