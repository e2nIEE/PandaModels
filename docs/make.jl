using Documenter, PandaModels

makedocs(
    modules = [PandaModels],
    authors = "MMajidi137",
    repo = "https://github.com/MMajidi137/PandaModels.jl/blob/{commit}{path}#L{line}",
    sitename = "PandaModels.jl",
    modules = [PandaModels]
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        canonical="https://mmajidi137.github.io/PandaModels.jl/stable/",
        assets = String[],
    ),
    pages = [
        "Home" => "index.md",
        "Manual" => ["Getting Started" => "quickguide.md"],
        "Tutorials" => [
            # "Power Flow" => "pf.md",
            "Optimal Power Flow" => "opf.md",
            "Optimal Transmission Switching" => "ots.md",
            # "Timeseries and Multinetwork" => "ts_mn.md",
            "Optimal MultiNetwork Storage" => "omns.md",
            "Transmission Network Expansion Planning" => "tnep.md",
            # "Optimal Voltage Deviation" => "vd.md",
            # "Radial Distribution Network" => "rds.md",
        ],
        "Developer" => [
            "Develop Mode" => "develop.md",
            # "Model Guidlines" => "model.md",
            # "Call Model in pandapower" => "modelpp.md",
            "Add Test" => "test.md",
        ],
    ],
    doctest = true,
    linkcheck = true,
    # format = Documenter.HTML(
    #     # See https://github.com/JuliaDocs/Documenter.jl/issues/868
    #     prettyurls = get(ENV, "CI", nothing) == "true",
    #     analytics = "UA-178297470-1",
    #     collapselevel = 1,
    #     )
)

deploydocs(
    repo = "github.com/MMajidi137/PandaModels.git",
    push_preview = true
)
