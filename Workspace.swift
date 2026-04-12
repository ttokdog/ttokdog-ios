import ProjectDescription

let workspace = Workspace(
    name: "ttokdog",
    projects: [
        "Projects/*",
    ],
    generationOptions: .options(enableAutomaticXcodeSchemes: true)
)
