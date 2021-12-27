SassInfo = provider(
    doc = "Sass",
    fields = {
        "name": "CommonJS name",
        "package": "CommonJS package",
        "transitive_deps": "Transitive deps",
        "transitive_descriptors": "Transitive descriptors",
        "transitive_packages": "Transitive packages",
        "transitive_sass": "Transitive Sass files",
    },
)

SassCompilerInfo = provider(
    doc = "Sass compiler",
    fields = {
        "bin": "Executable",
    },
)
