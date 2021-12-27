load(":providers.bzl", "SassCompilerInfo", "SassInfo")
load("@better_rules_javascript//commonjs:providers.bzl", "CjsEntries", "CjsInfo", "create_dep", "create_entries", "default_strip_prefix", "gen_manifest", "output_prefix", "package_path")
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")
load("@better_rules_javascript//typescript:rules.bzl", "ts_library", "tsconfig")

def configure_sass_compiler(name, sass, visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = name,
        descriptors = ["@better_rules_css//sass/compiler:descriptors"],
        strip_prefix = "better_rules_css/sass/compiler",
        visibility = ["//visibility:private"],
    )

    tsconfig(
        name = "%s.tsconfig" % name,
        src = "@better_rules_css//sass/compiler:tsconfig",
        dep = "@better_rules_javascript//rules:tsconfig",
        root = "%s.root" % name,
        path = "tsconfig.json",
        visibility = ["//visibility:private"],
    )

    ts_library(
        compiler = "@better_rules_css//rules:tsc",
        name = "%s.lib" % name,
        srcs = ["@better_rules_css//sass/compiler:src"],
        deps = [
            sass,
            "@better_rules_css_npm//@types/argparse:lib",
            "@better_rules_css_npm//argparse:lib",
            "@better_rules_css_npm//enhanced-resolve:lib",
            "@better_rules_css_npm//sass-loader:lib",
            "@better_rules_javascript//commonjs/package:lib",
            "@better_rules_javascript//nodejs/fs-linker:lib",
            "@better_rules_javascript//worker/lib",
        ],
        strip_prefix = "better_rules_css/sass/compiler",
        config = "%s.tsconfig" % name,
        root = "%s.root" % name,
        visibility = ["//visibility:private"],
    )

    nodejs_binary(
        name = "%s.bin" % name,
        dep = "%s.lib" % name,
        main = "src/main.js",
        visibility = ["//visibility:private"],
    )

    sass_compiler(
        name = name,
        bin = ":%s.bin" % name,
        visibility = visibility,
    )

def _sass_compiler_impl(ctx):
    bin = ctx.attr.bin[DefaultInfo]

    sass_compiler_info = SassCompilerInfo(
        bin = bin,
    )

    return [sass_compiler_info]

sass_compiler = rule(
    implementation = _sass_compiler_impl,
    attrs = {
        "bin": attr.label(
            executable = True,
            cfg = "exec",
            mandatory = True,
        ),
    },
)

def _sass_bundle(ctx):
    compiler = ctx.attr.compiler[SassCompilerInfo]
    out = ctx.actions.declare_file(ctx.attr.out)
    dep = ctx.attr.dep[SassInfo]
    cjs_info = ctx.attr.root[CjsInfo]
    main = ctx.attr.main

    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)

    package_manifest = ctx.actions.declare_file("%s/package-manifest.json" % ctx.attr.name)
    gen_manifest(
        actions = ctx.actions,
        manifest_bin = ctx.attr._manifest[DefaultInfo],
        manifest = package_manifest,
        packages = dep.transitive_packages,
        deps = dep.transitive_deps,
        globals = [],
        package_path = package_path,
    )

    args = ctx.actions.args()
    args.add("--manifest", package_manifest)
    args.add("%s/%s" % (dep.package.path, main))
    args.add(out)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    ctx.actions.run(
        arguments = [args],
        executable = compiler.bin.files_to_run.executable,
        mnemonic = "SassCompile",
        inputs = depset([package_manifest], transitive = [dep.transitive_descriptors, dep.transitive_sass]),
        tools = [compiler.bin.files_to_run],
        outputs = [out],
    )

    default_info = DefaultInfo(
        files = depset([out]),
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = depset([cjs_info.package]),
        transitive_deps = depset(),
        transitive_files = depset([out] + cjs_info.descriptors),
    )

    return [cjs_entries, default_info]

sass_bundle = rule(
    attrs = {
        "compiler": attr.label(
            mandatory = True,
            providers = [SassCompilerInfo],
        ),
        "out": attr.string(
            mandatory = True,
        ),
        "dep": attr.label(
            mandatory = True,
            providers = [SassInfo],
        ),
        "main": attr.string(
            mandatory = True,
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "_manifest": attr.label(
            cfg = "exec",
            executable = True,
            default = "@better_rules_javascript//commonjs/manifest:bin",
        ),
    },
    implementation = _sass_bundle,
)

def _sass_library_impl(ctx):
    cjs_info = ctx.attr.root[CjsInfo]
    srcs = ctx.files.srcs
    prefix = output_prefix(cjs_info.package.path, ctx.label, ctx.actions)
    if ctx.attr.prefix:
        prefix = "%s/%s" % (prefix, ctx.attr.prefix)
    strip_prefix = ctx.attr.strip_prefix or default_strip_prefix(ctx)
    deps = [dep[SassInfo] for dep in ctx.attr.deps]

    sass = create_entries(
        ctx = ctx,
        actions = ctx.actions,
        srcs = srcs,
        prefix = prefix,
        strip_prefix = strip_prefix,
    )

    transitive_packages = depset(
        [cjs_info.package],
        transitive = [sass_info.transitive_packages for sass_info in deps],
    )
    transitive_deps = depset(
        [create_dep(
            id = cjs_info.package.id,
            dep = dep[SassInfo].package.id,
            label = dep.label,
            name = dep[SassInfo].name,
        ) for dep in ctx.attr.deps],
        transitive = [sass_info.transitive_deps for sass_info in deps],
    )
    transitive_descriptors = depset(
        cjs_info.descriptors,
        transitive = [sass_info.transitive_descriptors for sass_info in deps],
    )
    transitive_sass = depset(
        sass,
        transitive = [sass_info.transitive_sass for sass_info in deps],
    )

    sass_info = SassInfo(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = transitive_packages,
        transitive_descriptors = transitive_descriptors,
        transitive_deps = transitive_deps,
        transitive_sass = transitive_sass,
    )

    cjs_entries = CjsEntries(
        name = cjs_info.name,
        package = cjs_info.package,
        transitive_packages = transitive_packages,
        transitive_deps = transitive_deps,
        transitive_files = depset(transitive = [transitive_descriptors, transitive_sass]),
    )

    return [cjs_entries, sass_info]

sass_library = rule(
    attrs = {
        "deps": attr.label_list(
            providers = [SassInfo],
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "srcs": attr.label_list(
            doc = "Sass sources",
            allow_files = [".scss"],
        ),
        "strip_prefix": attr.string(
            doc = "Strip prefix.",
        ),
        "prefix": attr.string(
            doc = "Prefix",
        ),
    },
    implementation = _sass_library_impl,
)
