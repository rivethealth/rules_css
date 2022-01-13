#!/bin/bash -e
RUNFILES_DIR="$0.runfiles"

cd "$BUILD_WORKSPACE_DIRECTORY"

function escape_pattern {
  <<< "$1" sed 's/[\/&]/\\&/g'
}

test_packages="$( \
    find . -path '*/bazel/*' \( -name BUILD -o -name BUILD.bazel \) \
    | sed -e 's:/[^/]*$::' -e 's:^\./::' \
)"

file_packages="$( \
    (find . -name BUILD -o -name BUILD.bazel) \
    | sed -e 's:/[^/]*$::' -e 's:^\./::' -e 's:^:@better_rules_css_files//files/:' -e 's:/.$::' \
)"

packages="$(
    (echo "$test_packages" && echo "$file_packages") \
    | tr '\n' , \
    | sed 's/,$//' \
)"

sed -e "s/%{deleted_packages}/$(escape_pattern "$packages")/g" "$RUNFILES/better_rules_css/tools/deleted.bazelrc.tpl" > tools/deleted.bazelrc
