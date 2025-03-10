#!/usr/bin/env bash

set -e
set -o pipefail

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

NIXPKGS_MASTER_RAW="https://raw.githubusercontent.com/NixOS/nixpkgs/refs/heads/master"
PACKAGE_PATH="/pkgs/by-name/co/code-cursor/package.nix"

OUTPUT_PATH="$SCRIPT_DIR/default.nix"
curl -s "$NIXPKGS_MASTER_RAW$PACKAGE_PATH" > "$OUTPUT_PATH"
