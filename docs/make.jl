using Documenter

makedocs(
    sitename = "JCGE",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        assets = ["assets/jcge_logo_light.png", "assets/jcge_logo_dark.png"],
        logo = "assets/jcge_logo_light.png",
        logo_dark = "assets/jcge_logo_dark.png",
    ),
    pages = [
        "Home" => "index.md",
        "Packages" => "packages.md",
        "Guides" => [
            "Modeling" => "guides/modeling.md",
            "Running Models" => "guides/running.md",
            "Blocks" => "guides/blocks.md",
            "Calibration" => "guides/calibration.md",
            "Output & Reporting" => "guides/output.md",
            "Imports" => "guides/imports.md",
        ],
    ],
)

deploydocs(
    repo = "github.com/equicirco/JCGE.jl.git",
    branch = "gh-pages",
    devbranch = "main",
)
