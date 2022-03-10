CssInfo = provider(
    doc = "CSS",
    fields = {
        "transitive_files": "Depset of CSS and descriptor files",
    },
)

def create_css_info(cjs_root, files = [], deps = []):
    return CssInfo(
        transitive_files = depset(
            files,
            transitive = [cjs_root.transitive_files] + [dep.transitive_files for dep in deps],
        ),
    )
