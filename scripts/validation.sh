#!/usr/bin/bash

set -euo pipefail

if [[ -n "$(find /etc -name '*.pacnew')" ]]; then
  echo "Pacman package conflict files have been found. Writing a new quirk might be needed." >&2
  exit 1
fi
