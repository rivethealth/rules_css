load("@better_rules_javascript//commonjs:providers.bzl", "CjsInfo", "create_cjs_info", "gen_manifest", "package_path")
load("@better_rules_javascript//commonjs:rules.bzl", "cjs_root")
load("@better_rules_javascript//javascript:rules.bzl", "js_export")
load("@better_rules_javascript//nodejs:rules.bzl", "nodejs_binary")
load("@better_rules_javascript//util:path.bzl", "output", "output_name")
load("//css:providers.bzl", "CssInfo", "create_css_info")
load(":providers.bzl", "SassCompilerInfo")

def configure_sass_compiler(name, sass, visibility = None):
    cjs_root(
        name = "%s.root" % name,
        package_name = name,
        descriptors = ["@better_rules_css//sass/compiler:descriptors"],
        strip_prefix = "/sass/compiler",
        visibility = ["//visibility:private"],
    )

    js_export(
        name = "%s.lib" % name,
        dep = "@better_rules_css//sass/compiler:lib",
        deps = [sass],
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
    actions = ctx.actions
    cjs_root = ctx.attr.root[CjsInfo]
    compiler = ctx.attr.compiler[SassCompilerInfo]
    dep = ctx.attr.dep[CssInfo]
    dep_cjs = ctx.attr.dep[CjsInfo]
    label = ctx.label
    main = ctx.attr.main
    manifest_bin = ctx.attr._manifest[DefaultInfo]
    name = ctx.attr.name
    out = ctx.outputs.out

    map = actions.declare_file("%s.map" % name)  # TODO base on out

    package_manifest = actions.declare_file("%s.package-manifest.json" % name)
    gen_manifest(
        actions = actions,
        manifest_bin = manifest_bin,
        manifest = package_manifest,
        packages = dep_cjs.transitive_packages,
        deps = dep_cjs.transitive_links,
        package_path = package_path,
    )

    args = actions.args()
    args.add("--manifest", package_manifest)
    args.add("%s/%s" % (dep_cjs.package.path, main))
    args.add(out)
    args.add(map)
    args.set_param_file_format("multiline")
    args.use_param_file("@%s", use_always = True)

    actions.run(
        arguments = [args],
        executable = compiler.bin.files_to_run.executable,
        mnemonic = "SassCompile",
        inputs = depset([package_manifest], transitive = [dep.transitive_files]),
        tools = [compiler.bin.files_to_run],
        outputs = [out, map],
        execution_requirements = {
            "supports-workers": "1",
        },
    )

    default_info = DefaultInfo(
        files = depset([out]),
    )

    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        label = label,
    )

    css_info = CssInfo(
        transitive_files = depset([out, map]),
    )

    return [cjs_info, css_info, default_info]

sass_bundle = rule(
    attrs = {
        "compiler": attr.label(
            mandatory = True,
            providers = [SassCompilerInfo],
        ),
        "out": attr.output(
            mandatory = True,
        ),
        "dep": attr.label(
            mandatory = True,
            providers = [CssInfo],
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
    provides = [CjsInfo, CssInfo],
)

def _sass_library_impl(ctx):
    actions = ctx.actions
    cjs_root = ctx.attr.root[CjsInfo]
    cjs_deps = [dep[CjsInfo] for dep in ctx.attr.deps]
    cjs_globals = [dep[CjsInfo] for dep in ctx.attr.global_deps]
    css_deps = [dep[CssInfo] for dep in ctx.attr.deps + ctx.attr.global_deps]
    output_ = output(label = ctx.label, actions = actions)
    prefix = ctx.attr.prefix
    strip_prefix = ctx.attr.strip_prefix
    label = ctx.label

    css = []
    for file in ctx.files.srcs:
        path = output_name(
            file = file,
            label = label,
            prefix = prefix,
            strip_prefix = strip_prefix,
        )
        if file.path == "%s/%s" % (output_.path, path):
            css_ = file
        else:
            css_ = actions.declare_file(path)
            actions.symlink(
                target_file = file,
                output = css_,
            )
        css.append(css_)

    cjs_info = create_cjs_info(
        cjs_root = cjs_root,
        deps = cjs_deps,
        files = css,
        label = label,
    )

    css_info = create_css_info(
        files = css,
        cjs_root = cjs_root,
        deps = css_deps,
    )

    default_info = DefaultInfo(files = depset(css))

    return [cjs_info, default_info, css_info]

sass_library = rule(
    attrs = {
        "global_deps": attr.label_list(
            providers = [CjsInfo, CssInfo],
        ),
        "deps": attr.label_list(
            providers = [CjsInfo, CssInfo],
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsInfo],
        ),
        "srcs": attr.label_list(
            doc = "Sass sources",
            allow_files = True,
        ),
        "strip_prefix": attr.string(
            doc = "Strip prefix.",
        ),
        "prefix": attr.string(
            doc = "Prefix",
        ),
    },
    implementation = _sass_library_impl,
    provides = [CssInfo],
)
