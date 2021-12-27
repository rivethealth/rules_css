CssInfo = provider(
    doc = "CSS",
    fields = {
        "name": "CommonJS name",
        "package": "CommonJS package struct",
        "transitive_deps": "Depset of dependency structs",
        "transitive_descriptors": "Depset of package descriptor files",
        "transitive_css": "Depset of JavaScript files",
        "transitive_packages": "Depset of packages",
        "transitive_srcs": "Depset of sources",
    },
)
