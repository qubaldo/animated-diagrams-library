#!/bin/sh
# Checks icon references, then prepends library.html to every diagram so each
# dist/*.html is one self-contained paste for the Confluence HTML macro.
set -eu
cd "$(dirname "$0")"

defined=$(grep -o 'symbol id="dd-i-[a-z0-9-]*' library.html | sed 's/.*"//')
used=$(grep -oh 'href="#dd-i-[a-z0-9-]*' diagrams/*.html | sed 's/.*#//' | sort -u)
shown=$(grep -o 'href="#dd-i-[a-z0-9-]*' diagrams/catalog.html | sed 's/.*#//')

fail=0
for i in $used; do
  echo "$defined" | grep -qx "$i" || { echo "undefined icon used in diagrams/: $i"; fail=1; }
done
for i in $defined; do
  echo "$shown" | grep -qx "$i" || { echo "icon missing from diagrams/catalog.html: $i"; fail=1; }
done
[ "$fail" = 0 ] || exit 1

rm -rf dist && mkdir dist
for f in diagrams/*.html; do
  cat library.html "$f" > "dist/$(basename "$f")"
done
echo "built $(ls dist | wc -l | tr -d ' ') files in dist/"
