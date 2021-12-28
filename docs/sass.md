# SASS

Sass-loader is used to resolve SASS modules.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [Example](#example)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Example


**package.json**

```json
{}
```

**lib.scss**

```scss
button {
    border: 1px solid red;
}
```

**styles.scss**

```scss
@import "lib";

body {
    margin: 0;
}
```

**BUILD.bazel**

```bzl
load("@better_rules_css//sass:rules.bzl", "sass_bundle", "sass_library")
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")

# SASS bundle
sass_bundle(
    compiler = "//:sassc",
    dep = ":styles",
    main = "styles.scss",
    name = "css",
)

# SASS library
sass_library(
    name = "lib",
    root = ":root",
    srcs = ["lib.scss"],
)

# package root
cjs_root(
  descriptors = ["package.json"],
  name = "root",
  package_name = "example",
)

# SASS library
sass_library(
    deps = [":lib"],
    name = "styles",
    root = ":root",
    srcs = ["styles.scss"],
    out = "styles.css",
)
```
