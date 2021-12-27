load("@better_rules_javascript//nodejs:workspace.bzl", nodejs_repositories = "repositories")
load("@better_rules_javascript//npm:workspace.bzl", "npm", npm_repositories = "repositories")
load(":npm_data.bzl", "PACKAGES", "ROOTS")

def css_repositories():
    nodejs_repositories()
    npm_repositories()

    npm("better_rules_css_npm", PACKAGES, ROOTS)
