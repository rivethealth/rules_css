load("@better_rules_javascript//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("@better_rules_javascript//typescript:workspace.bzl", "ts_directory_npm_plugin")
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load("//sass:workspace.bzl", "sass_directory_npm_plugin")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def css_repositories():
    packages = {}
    for id, package in PACKAGES.items():
        package = dict(package)
        package["deps"] = [dep for dep in package["deps"] if not dep["id"].startswith("fsevents@")]
        packages[id] = package

    plugins = [
        cjs_directory_npm_plugin(),
        ts_directory_npm_plugin(),
        sass_directory_npm_plugin(),
    ]
    npm("better_rules_css_npm", packages, ROOTS, plugins)
