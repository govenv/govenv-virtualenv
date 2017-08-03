#!/bin/sh
# Usage: PREFIX=/usr/local ./install.sh
#
# Installs govenv-virtualenv under $PREFIX.

set -e

cd "$(dirname "$0")"

if [ -z "${PREFIX}" ]; then
  PREFIX="/usr/local"
fi

BIN_PATH="${PREFIX}/bin"
SHIMS_PATH="${PREFIX}/shims"
HOOKS_PATH="${PREFIX}/etc/govenv.d"

mkdir -p "$BIN_PATH"
mkdir -p "$SHIMS_PATH"
mkdir -p "$HOOKS_PATH"

install -p bin/* "$BIN_PATH"
install -p shims/* "$SHIMS_PATH"
for hook in etc/govenv.d/*; do
  if [ -d "$hook" ]; then
    cp -RPp "$hook" "$HOOKS_PATH"
  else
    install -p -m 0644 "$hook" "$HOOKS_PATH"
  fi
done
