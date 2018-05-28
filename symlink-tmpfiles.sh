#!/usr/bin/env bash

# Test script: how fast is mass symlinking from a default tmpdir to new ones as they're created?
# Based on https://stackoverflow.com/a/1347190
# Usage: time ./symlink-tmpfiles.sh <default tmpdir> <test tmpdir>

DEFAULT_TMPDIR="$(realpath "$1")"
TEST_TMPDIR="$(realpath "$2")"

# echo -n "symlinking everything in $DEFAULT_TMPDIR to $TEST_TMPDIR... "
mkdir -p "$TEST_TMPDIR"
cd "$TEST_TMPDIR"
find "$DEFAULT_TMPDIR" -mindepth 1 -depth -type d -printf "%P\n" | while read dir; do mkdir -p "$dir"; done
find "$DEFAULT_TMPDIR" -type f -printf "%P\n" | while read file; do ln -fs "${DEFAULT_TMPDIR}/$file" "$file"; done
find "$DEFAULT_TMPDIR" -type l -printf "%P\n" | while read link; do ln -fs "${DEFAULT_TMPDIR}/$link" "$link"; done
# echo "done"

# echo -n "deleting $TEST_TMPDIR... "
# rm -rf "$TEST_TMPDIR"
# echo "done"
