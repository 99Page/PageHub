import ProjectDescription


let infoPlist: [String: Plist.Value] = [
    "CFBundleShortVersionString": "1.0",
    "CFBundleVersion": "1",
    "UIMainStoryboardFile": "",
    "UILaunchStoryboardName": "LaunchScreen",
    "CFBundleURLTypes": [
        "CFBundleTypeRole": "Editor",
        "CFBundleURLSchemes": [
            "com.googleusercontent.apps.754260062806-9sij6if8v64diutv39ql0ts9pucnpn9r"
        ]
    ],
    "NSAppTransportSecurity": [
        "NSAllowsArbitraryLoads": true
    ]
]


/// 이곳에 명시된 버전을 이용해서 firebase의 데이터를 업데이트하고 있습니다.
/// 따라서 버전 문자열 외에는 수정에 유의합니다.
let deploymentTarget: DeploymentTargets = .iOS("18.0")

let destinations: Destinations = .iOS

let appName = "PageHub"
let appBundleId = "com.pagehub.app"

let target = Target.target(
    name: appName,
    destinations: destinations,
    product: .app,
    bundleId: appBundleId,
    deploymentTargets: deploymentTarget,
    infoPlist: .extendingDefault(with: infoPlist),
    sources: ["Sources/**"],
    resources: [
        "Resources/**",
        "../Documentation/**"
    ],
    dependencies: [
        .project(target: "Common", path: "../Common"),
        .package(product: "FirebaseCore"),
        .package(product: "FirebaseFirestore"),
        .package(product: "GoogleSignIn"),
        .package(product: "FirebaseAuth"),
        .package(product: "HighlightSwift")
    ]
)

let testTarget = Target.target(
    name: "\(appName)Tests",
    destinations: .iOS,
    product: .unitTests,
    bundleId: "\(appBundleId).test",
    deploymentTargets: deploymentTarget,
    sources: ["Tests/**"],
    dependencies: [
        .project(target: "Common", path: "../Common"),
        .target(name: "PageHub"),
    ]
)

let firebaseURL = "https://github.com/firebase/firebase-ios-sdk.git"
let firebaseVersion: Package.Requirement = .upToNextMajor(from: "11.4")

let highlightSwiftURL = "https://github.com/appstefan/HighlightSwift.git"
let hightSwiftVersion: Package.Requirement = .upToNextMajor(from: "1.1.0")

let googleSignInURL = "https://github.com/google/GoogleSignIn-iOS.git"
let googleSignInVersion: Package.Requirement = .upToNextMajor(from: "8.0.0")


let project = Project(
    name: appName,
    organizationName: "Page",
    packages: [
        .remote(url: firebaseURL, requirement: firebaseVersion),
        .remote(url: highlightSwiftURL, requirement: hightSwiftVersion),
        .remote(url: googleSignInURL, requirement: googleSignInVersion)
    ],
    settings: .settings(
        base: [
            "SWIFT_VERSION": "6.0"
        ]
    ),
    targets: [target, testTarget]
)
