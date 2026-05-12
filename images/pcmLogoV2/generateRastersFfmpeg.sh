#!/usr/bin/env bash

set -euo pipefail

VECTOR_DIR="vector"
OUTPUT_BASE="raster"
WIDTHS=(128 256 512 1024 2048 4096)

if [[ ! -d "$VECTOR_DIR" ]]; then
    echo "Error: '$VECTOR_DIR' directory not found."
    exit 1
fi

shopt -s nullglob
svgs=("$VECTOR_DIR"/*.svg)

if [[ ${#svgs[@]} -eq 0 ]]; then
    echo "No .svg files found in '$VECTOR_DIR'."
    exit 0
fi

for svg in "${svgs[@]}"; do
    basename="${svg##*/}"       # e.g. icon.svg
    stem="${basename%.svg}"     # e.g. icon
    out_dir="$OUTPUT_BASE/$stem"

    mkdir -p "$out_dir"
    echo "Processing: $svg -> $out_dir/"

    for width in "${WIDTHS[@]}"; do
        out_file="$out_dir/${stem}_${width}.png"
        echo "  Rasterizing at width $width -> $out_file"
        ffmpeg -width $width -i "$svg" "$out_file" -y -loglevel error
    done
done

echo "Done."
