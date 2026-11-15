#!/usr/bin/env sh
# Builds the user guide as HTML (main format) and PDF into ./out.
set -eu
cd "$(dirname "$0")"
mkdir -p out
typst compile --font-path fonts main.typ out/musicus-user-guide.pdf
typst compile --features html --font-path fonts main.typ out/musicus-user-guide.html
echo "out/musicus-user-guide.html and out/musicus-user-guide.pdf written"
