#!/bin/bash

# Copyright (c) 2020 Maurizio Tomasi
#
# This Bash script downloads the "fmt" C++ library and installs it in
# the current directory.

FMT_VERSION="8.1.1"

download_file() {
    filename="$1"
    dest="$2"

    if [ -z "$dest" ]; then
        dest=$filename
    fi

    destdir=$(dirname "$dest")
    if [ -n "$destdir" ]; then
        mkdir -p "$destdir"
    fi

    printf "Downloading file '%s' (version %s)\n" "$filename" "$FMT_VERSION"

    url="https://raw.githubusercontent.com/fmtlib/fmt/${FMT_VERSION}/$filename"
    
    if which curl >/dev/null 2>/dev/null; then
        curl -s "$url" > "$dest"
    elif which wget >/dev/null 2>/dev/null; then
        wget --quiet --output-document "$dest" "$url"
    else
        echo "Neither curl nor wget seem to be installed, aborting..."
        exit 1
    fi
}

echo "Going to download fmt library version ${FMT_VERSION} in current directory"
echo "Press ENTER to continue, or Ctrl+C to quit…"
read -s

for filename in fmt/core.h fmt/format.h fmt/format-inl.h; do
    download_file "include/$filename" "$filename"
done

download_file src/format.cc format.cc

cat > fmtlib.h <<EOF
#pragma once

#ifndef __has_include
    // No way to check if <format> exists, so play safe and use fmt
    #include "fmt/format.h"
#else
    #if __has_include(<format>)
        // Hurrah, we're using a C++20 compiler!
        #include <format>
        namespace fmt = std::format;
    #else
        // No full C++20 support, sigh! Use fmt
        #include "fmt/format.h"
    #endif
#endif
EOF

cat <<EOF
The library has been downloaded. To use it, include in your C++ files the lines

    #include "fmtlib.h"

and be sure to add "format.cc" in your Makefile when building executables, e.g.:

    CXXFLAGS = -g -Wall --pedantic -std=c++11

    myprogram: myprogram.cc routines.cc format.cc
EOF
