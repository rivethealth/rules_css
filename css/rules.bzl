load("@better_rules_javascript//commonjs:providers.bzl", "CjsInfo", "CjsRootInfo", "create_cjs_info")
load("@better_rules_javascript//javascript:providers.bzl", "JsInfo", "create_js_info")
load("@better_rules_javascript//util:path.bzl", "output", "output_name", "runfile_path")
load(":providers.bzl", "CssInfo", "create_css_info")

def _css_library_impl(ctx):
    actions = ctx.actions
    cjs_root = ctx.attr.root[CjsRootInfo]
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
        globals = cjs_globals,
        label = label,
    )

    css_info = create_css_info(
        files = cjs_root.descriptors + css,
        deps = css_deps,
    )

    default_info = DefaultInfo(files = depset(css))

    return [cjs_info, default_info, css_info]

css_library = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies.",
            providers = [CjsInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies.",
            providers = [CjsInfo],
        ),
        "prefix": attr.string(
            doc = "Prefix to add.",
        ),
        "root": attr.label(
            mandatory = True,
            providers = [CjsRootInfo],
        ),
        "srcs": attr.label_list(
            allow_files = True,
            doc = "JavaScript files and data.",
        ),
        "strip_prefix": attr.string(
            doc = "Package-relative prefix to remove.",
        ),
    },
    doc = "CSS library",
    implementation = _js_library_impl,
    provides = [CjsInfo, JsInfo],
)

def _js_export_impl(ctx):
    cjs_dep = ctx.attr.dep[CjsInfo]
    cjs_deps = [target[CjsInfo] for target in ctx.attr.deps]
    cjs_extra = [target[CjsInfo] for target in ctx.attr.extra_deps]
    cjs_globals = [target[CjsInfo] for target in ctx.attr.global_deps]
    default_dep = ctx.attr.dep[DefaultInfo]
    package_name = ctx.attr.package_name
    js_dep = ctx.attr.dep[JsInfo]
    js_deps = [target[JsInfo] for target in ctx.attr.global_deps + ctx.attr.deps + ctx.attr.extra_deps]
    label = ctx.label

    default_info = default_dep

    cjs_info = create_cjs_info(
        cjs_root = struct(
            package = cjs_dep.package,
            name = package_name,
            descriptors = [],
        ),
        deps = cjs_deps,
        globals = cjs_globals,
        label = label,
    )
    cjs_info = CjsInfo(
        name = cjs_dep.name,
        transitive_files = depset(transitive = [c.transitive_files for c in [cjs_dep, cjs_info] + cjs_extra]),
        package = cjs_info.package,
        transitive_links = depset(transitive = [c.transitive_links for c in [cjs_dep, cjs_info] + cjs_extra]),
        transitive_packages = depset(transitive = [c.transitive_packages for c in [cjs_dep, cjs_info] + cjs_extra]),
    )

    js_info = create_js_info(
        deps = [js_dep] + js_deps,
    )

    return [cjs_info, default_info, js_info]

css_export = rule(
    attrs = {
        "deps": attr.label_list(
            doc = "Dependencies to add.",
            providers = [CjsInfo, CssInfo],
        ),
        "extra_deps": attr.label_list(
            doc = "Extra dependencies to add.",
            providers = [CjsInfo, CssInfo],
        ),
        "global_deps": attr.label_list(
            doc = "Global dependencies to add.",
            providers = [CjsInfo, CssInfo],
        ),
        "package_name": attr.string(
            doc = "Dependency name. Defaults to root's name.",
        ),
        "dep": attr.label(
            doc = "JavaScript library.",
            mandatory = True,
            providers = [CjsInfo, CssInfo],
        ),
    },
    doc = "Add dependencies, or use alias.",
    implementation = _js_export_impl,
    provides = [CjsInfo, CssInfo],
)

def _js_import_css_impl(ctx):
    cjs_info = ctx.attr.dep[CjsInfo]
    css_info = ctx.attr.dep[CssInfo]
    default_info = ctx.attr.dep[DefaultInfo]

    js_info = JsInfo(
        transitive_files = css_info.transitive_files,
    )

    return [default_info, cjs_info, js_info]

js_import_css = rule(
    attrs = {
        "dep": attr.label(
            mandatory = True,
            providers = [CssInfo, CjsInfo],
        ),
    },
    doc = "Use CSS as JS.",
    implementation = _js_import_css_impl,
    provides = [CjsInfo, JsInfo],
)
