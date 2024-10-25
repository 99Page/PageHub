import ProjectDescription

let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen"
]


let deploymentTarget: DeploymentTargets = .multiplatform(iOS: "18.0")
let destinations: Destinations = [.iPad, .iPhone, .macWithiPadDesign]

let appBundleId = "com.page.pagehub"

let target = Target.target(
    name: "PageHub",
    destinations: destinations,
    product: .app,
    bundleId: appBundleId,
    deploymentTargets: deploymentTarget,
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["PageHub/Sources/**"],
    resources: ["PageHub/Resources/**"],
    dependencies: [
        .package(product: "ComposableArchitecture")
    ]
)

let testTarget = Target.target(
    name: "PageHubTests",
    destinations: destinations,
    product: .unitTests,
    bundleId: "\(appBundleId).test",
    deploymentTargets: deploymentTarget,
    sources: ["PageHub/Tests/**"],
    dependencies: [
        .target(name: "PageHub")
    ]
)

let tcaURL = "https://github.com/pointfreeco/swift-composable-architecture.git"
let tcaVersion: Package.Requirement = .upToNextMajor(from: "1.13.0")


let project = Project(
    name: "PageHub",
    organizationName: "Page",
    packages: [
        .remote(url: tcaURL, requirement: tcaVersion),
    ],
    settings: nil,
    targets: [target, testTarget]
)
