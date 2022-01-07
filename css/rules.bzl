load(":providers.bzl", "CssInfo")
load("@better_rules_javascript//javascript:providers.bzl", "JsInfo")

def _js_import_css_impl(ctx):
    css_info = ctx.attr.dep[CssInfo]

    js_info = JsInfo(
        name = css_info.name,
        package = css_info.package,
        transitive_deps = css_info.transitive_deps,
        transitive_descriptors = css_info.transitive_descriptors,
        transitive_css = css_info.transitive_css,
        transitive_packages = css_info.transitive_packages,
        transitive_srcs = css_info.transitive_srcs,
    )

    return [js_info]

js_import_css = rule(
    attrs = {
        "dep": ctx.label(
            mandatory = True,
            providers = [CssInfo],
        ),
    },
    implementation = _js_import_css_impl,
)
