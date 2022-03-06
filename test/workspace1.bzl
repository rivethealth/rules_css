load("@better_rules_javascript//commonjs:workspace.bzl", "cjs_directory_npm_plugin")
load("@better_rules_javascript//npm:workspace.bzl", "npm")
load("@better_rules_javascript//rules:workspace.bzl", javascript_repositories = "repositories")
load("@better_rules_javascript//typescript:workspace.bzl", "ts_directory_npm_plugin")
load("@rules_proto//proto:repositories.bzl", "rules_proto_dependencies", "rules_proto_toolchains")
load("@rules_proto_grpc//:repositories.bzl", "rules_proto_grpc_repos", "rules_proto_grpc_toolchains")
load("//rules:npm_data.bzl", "PACKAGES", "ROOTS")
load("//rules:workspace.bzl", "css_repositories")

def test_repositories1():
    # Protobuf

    rules_proto_dependencies()

    rules_proto_toolchains()

    # Protobuf

    rules_proto_grpc_toolchains()

    rules_proto_grpc_repos()

    # JavaScript

    javascript_repositories()

    # CSS

    css_repositories()

    plugins = [
        cjs_directory_npm_plugin(),
        ts_directory_npm_plugin(),
    ]
    npm("npm", PACKAGES, ROOTS, plugins)
