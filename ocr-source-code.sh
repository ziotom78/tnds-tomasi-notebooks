#!/bin/sh

if [ "$1" == "" ]; then
    echo "Usage: $(basename $0) URL"
    exit 1
fi

readonly url="$1"

curl $url | tesseract - - --psm 6 | xclip -selection clipboard

echo "Text copied to the clipboard"

