#!/usr/bin/env bash

# Copy filepath to clipboard
FILEPATH=$1
realpath $FILEPATH | tr -d "\n" | xclip -selection clipboard
