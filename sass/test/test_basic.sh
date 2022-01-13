#!/bin/sh -e
cd sass/test/bazel
unset RUNFILES_DIR
unset TEST_TMPDIR
bazel info output_base
bazel build basic:css
bazel build basic:styles.css
