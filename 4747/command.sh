#!/bin/bash
# Usage: ./command input > output

# NOTE: This should be put below the comparison on line 13 so the target isn't created and then this
#       command issues error.
#       see this thread: https://pairlist4.pair.net/pipermail/scons-users/2025-July/009515.html
# Copy source to destination
cp "$1" "$2"

# If the input file stats with 'bad' inject an error AFTER creating the output file.

first_line=$(head -n 1 "$1")

if [[ "$first_line" == bad* ]]; then
  exit 1
fi



exit 0
