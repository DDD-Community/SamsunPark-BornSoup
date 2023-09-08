import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "Application",
    projects: [
        "Projects/OZeon",
        "Projects/Modules/DataKit",
        "Projects/Modules/DomainKit",
        "Projects/Modules/CoreKit",
        "Projects/Modules/NetworkKit",
        "Projects/Modules/DesignSystemKit",
        "Projects/Modules/PresentationKit",
        "Projects/Modules/ThirdPartyManager"
    ],
    schemes: [
        Scheme(
            name: "OZeonApp",
            buildAction: .buildAction(targets: [
                .project(path: "Projects/OZeon", target: "OZeon"),
                .project(path: "Projects/Modules/DataKit", target: "DataKit"),
                .project(path: "Projects/Modules/DomainKit", target: "DomainKit"),
                .project(path: "Projects/Modules/CoreKit", target: "CoreKit"),
                .project(path: "Projects/Modules/NetworkKit", target: "NetworkKit"),
                .project(path: "Projects/Modules/DesignSystemKit", target: "DesignSystemKit"),
                .project(path: "Projects/Modules/PresentationKit", target: "PresentationKit"),
                .project(path: "Projects/Modules/ThirdPartyManager", target: "ThirdPartyManager")
            ])
        )
    ],
    generationOptions: .options(
        autogeneratedWorkspaceSchemes: .disabled
    )
)
