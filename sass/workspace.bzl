load(":providers.bzl", "sass_npm_label")

def _sass_npm_alias_build(repo):
    return """
alias(
    name = "sass",
    actual = {label}
)
    """.strip().format(
        label = json.encode(sass_npm_label(repo)),
    )

def _sass_directory_npm_package_build(package):
    return """
load("@better_rules_css//sass:rules.bzl", "sass_library")

sass_library(
    name = "sass",
    root = ":root",
    deps = {deps},
    srcs = [":files"],
)
    """.strip().format(
        deps = json.encode([sass_npm_label(dep) for dep in package.deps]),
    )

def _sass_npm_package_build(package):
    return """
load("@better_rules_css//sass:rules.bzl", "sass_library")

sass_library(
    name = "sass",
    root = ":root",
    deps = {deps},
    srcs = glob(["npm/**/*.scss"]),
    strip_prefix = "npm",
)
    """.strip().format(
        deps = json.encode([sass_npm_label(dep) for dep in package.deps]),
    )

def sass_directory_npm_plugin():
    def alias_build(repo):
        return _sass_npm_alias_build(repo)

    def package_build(package, files):
        return _sass_directory_npm_package_build(package)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )

def sass_npm_plugin():
    def alias_build(repo):
        return _sass_npm_alias_build(repo)

    def package_build(package, files):
        return _sass_npm_package_build(package)

    return struct(
        alias_build = alias_build,
        package_build = package_build,
    )
