import ProjectDescription


let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleURLTypes": [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": [
            "com.googleusercontent.apps.754260062806-hiqu60ubfs2g1kir79tpdefvj3707ggl"
        ]
    ]
]


let deploymentTarget: DeploymentTargets = .multiplatform(iOS: "18.0")
let destinations: Destinations = [.iPad, .iPhone, .macWithiPadDesign]

let appName = "PageHub"
let appBundleId = "com.page.pagehub"

let target = Target.target(
    name: appName,
    destinations: destinations,
    product: .app,
    bundleId: appBundleId,
    deploymentTargets: deploymentTarget,
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["PageHub/Sources/**"],
    resources: ["PageHub/Resources/**"],
    dependencies: [
        .package(product: "ComposableArchitecture"),
        .package(product: "FirebaseCore"),
        .package(product: "FirebaseFirestore"),
        .package(product: "GoogleSignIn"),
        .package(product: "FirebaseAuth")
    ]
)

let testTarget = Target.target(
    name: "\(appName)Tests",
    destinations: destinations,
    product: .unitTests,
    bundleId: "\(appBundleId).test",
    deploymentTargets: deploymentTarget,
    sources: ["PageHub/Tests/**"],
    dependencies: [
        .target(name: "PageHub"),
    ]
)

let tcaURL = "https://github.com/pointfreeco/swift-composable-architecture.git"
let tcaVersion: Package.Requirement = .upToNextMajor(from: "1.13.0")

let firebaseURL = "https://github.com/firebase/firebase-ios-sdk.git"
let firebaseVersion: Package.Requirement = .upToNextMajor(from: "11.4")

let googleSignInURL = "https://github.com/google/GoogleSignIn-iOS.git"
let googleSignInVersion: Package.Requirement = .upToNextMajor(from: "8.0.0")


let project = Project(
    name: appName,
    organizationName: "Page",
    packages: [
        .remote(url: tcaURL, requirement: tcaVersion),
        .remote(url: firebaseURL, requirement: firebaseVersion),
        .remote(url: googleSignInURL, requirement: googleSignInVersion)
    ],
    settings: nil,
    targets: [target, testTarget]
)
