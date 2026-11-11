#!/bin/bash
# Copy the bundled plug-in into the current user's Sibelius plug-in folder.
set -eu
# Resolve the payload relative to this script, not the Terminal working directory.
script_dir="$(cd -- "$(dirname -- "$0")" && pwd)"
plugin_name='SplitAtBeatBoundaries.plg'
source_file="$script_dir/$plugin_name"
destination_dir="${HOME:-}/Library/Application Support/Avid/Sibelius/Plugins/Custom"

fail() {
    printf '\nInstallation failed: %s\n' "$1" >&2
    if [ -t 0 ]; then read -r -p 'Press Return to close. ' ignored || true; fi
    exit 1
}
[ -f "$source_file" ] || fail "Keep $plugin_name in the same folder as this installer."
[ -n "${HOME:-}" ] || fail 'Cannot locate the user home folder.'

mkdir -p "$destination_dir" || fail 'Cannot create the plug-in folder.'
cp -f "$source_file" "$destination_dir/$plugin_name" || fail 'Cannot copy the plug-in.'

printf '\nInstalled: %s\nRestart Sibelius, then run: Split at Beat Boundaries\n' "$destination_dir/$plugin_name"
