#!/usr/bin/env bash

# Note: this file purposely starts with 05_ so it's sourced first in all the things in
# this folder (after direnv setup), which makes things in bin/ available for other scripts.

# exit on error, unset vars, pipefail
set -euo pipefail

# Get the directory of the script
ROOT_DIR="${DIRENV_ROOT}"

# Add ROOT_DIR/bin to the PATH
export PATH="$ROOT_DIR/bin:$PATH"
echo "Added $ROOT_DIR/bin to PATH"