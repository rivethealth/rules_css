CssInfo = provider(
    doc = "CSS",
    fields = {
        "name": "CommonJS name",
        "package": "CommonJS package struct",
        "transitive_deps": "Depset of dependency structs",
        "transitive_files": "Depset of CSS and descriptor files",
        "transitive_packages": "Depset of packages",
        "transitive_srcs": "Depset of sources",
    },
)
