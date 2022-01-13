#!/usr/bin/env bash
set -e
if [ -z "$RUNFILES_DIR" ]; then
  export RUNFILES_DIR="$0.runfiles"
fi

if [ "$1" = check ]; then
    arg=
else
    arg=write
fi

"$RUNFILES_DIR/better_rules_css/tools/buildifier_format" "$arg"
"$RUNFILES_DIR/better_rules_css/tools/prettier_format" "$arg"
