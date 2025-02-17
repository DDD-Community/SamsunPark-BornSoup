import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let appName: String = "OZeon"

let infoPlist: [String: InfoPlist.Value] = [
    "CFBundleExecutable": "$(EXECUTABLE_NAME)",
    "CFBundleShortVersionString": "1.0.2",
    "CFBundleVersion": "1",
    "CFBundleIdentifier": "$(PRODUCT_BUNDLE_IDENTIFIER)",
    "CFBundleDisplayName": "오전",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleIcons": [
        "CFBundlePrimaryIcon": [
            "CFBundleIconFiles": [
                "AppIcon"
            ]
        ]
    ],
    "UIUserInterfaceStyle": "Light",
    "UISupportedInterfaceOrientations": [
        "UIInterfaceOrientationPortrait",
    ],
    "CFBundleURLTypes": [
        [
            "CFBundleTypeRole": "Editor",
            "CFBundleURLSchemes": ["kakao$(KAKAO_APP_KEY)"]
        ]
    ],
    "LSApplicationQueriesSchemes": ["kakaokompassauth", "kakaolink", "kakao$(KAKAO_APP_KEY)"],
    "KAKAO_REST_KEY": "$(KAKAO_REST_KEY)",
    "KAKAO_APP_KEY": "$(KAKAO_APP_KEY)"
]

// MARK: - App
let appTargets: [Target] = AppFactory(
    dependency: AppFactory.Dependency(
        appDependencies: [
            Dep.Project.CoreKit,
            Dep.Project.DIKit,
            Dep.Project.DataKit,
            Dep.Project.DomainKit,
            Dep.Project.PresentationKit
        ],
        unitTestsDependencies: []
    )
).build(
    payload: AppFactory.Payload(
        bundleID: "kr.ddd.ozeon.\(appName)",
        name: appName,
        platform: .iOS,
        infoPlist: infoPlist
    )
)

// MARK: - Project
let project = ProjectFactory(
    dependency: ProjectFactory.Dependency(
        appTargets: appTargets,
        frameworkTargets: []
    )
).build(
    payload: ProjectFactory.Payload(
        name: appName,
        organizationName: "kr.ddd.ozeon"
    )
)

