using Documenter
using JCGERuntime

makedocs(
    sitename = "JCGERuntime",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", "false") == "true",
        assets = ["assets/deepwiki-chat.css", "assets/deepwiki-chat.js", "assets/logo-theme.js", "assets/jcge_runtime_logo_light.png", "assets/jcge_runtime_logo_dark.png"],
        logo = "assets/jcge_runtime_logo_light.png",
        logo_dark = "assets/jcge_runtime_logo_dark.png",
    ),
    pages = [
        "Home" => "index.md",
        "Usage" => "usage.md",
        "API" => "api.md",
    ],
)


deploydocs(
    repo = "github.com/equicirco/JCGERuntime.jl",
    versions = ["stable" => "v^", "v#.#", "dev" => "dev"],
)
