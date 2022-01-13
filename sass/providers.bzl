SassInfo = provider(
    doc = "Sass",
    fields = {
        "name": "CommonJS name",
        "package": "CommonJS package",
        "transitive_deps": "Transitive deps",
        "transitive_files": "Transitive descriptors and Sass files",
        "transitive_packages": "Transitive packages",
    },
)

SassCompilerInfo = provider(
    doc = "Sass compiler",
    fields = {
        "bin": "Executable",
    },
)

def sass_npm_label(repo):
    return "@%s//:sass" % repo
