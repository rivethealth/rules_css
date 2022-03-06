SassCompilerInfo = provider(
    doc = "Sass compiler",
    fields = {
        "bin": "Executable",
    },
)

def sass_npm_label(repo):
    return "@%s//:sass" % repo
