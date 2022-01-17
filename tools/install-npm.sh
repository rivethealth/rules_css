#!/bin/sh -e
cd "$(dirname "$0")/.."

RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

# external deps
rm -fr node_modules
mkdir node_modules
tar xf "$RUNFILES_DIR/better_rules_css/nodejs_archive.tar" -C node_modules

# local deps
mkdir -p node_modules/@better-rules-css
ln -rs sass/compiler node_modules/@better-rules-css/sass-compiler
