#!/bin/sh -e
cd "$(dirname "$0")/.."

bazel build :archive
rm -fr .node_modules node_modules
mkdir .node_modules
tar xf bazel-bin/archive/modules.tar -C .node_modules
ln -s .node_modules/_ node_modules
