#!/bin/bash
mkdir -p dist/nodes/ResiliateEvents/
for img in assets/*.png; do 
    if [ -f "$img" ]; then
        echo "Resizing $img to 150x150 with transparent background..."
        # Remove any background chunk and preserve transparency
        convert "$img" -background none -resize 150x150! +set date:modify +set date:create -define png:exclude-chunk=bKGD "dist/$(basename "$img")"
        convert "$img" -background none -resize 150x150! +set date:modify +set date:create -define png:exclude-chunk=bKGD "dist/nodes/ResiliateEvents/$(basename "$img")"
    fi
done
