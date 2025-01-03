//
//  Project.swift
//  Packages
//
//  Created by 노우영 on 12/18/24.
//

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

let appName = "Common"
let appBundleId = "com.pagehub.common"

let target = Target.target(
    name: appName,
    destinations: destinations,
    product: .framework,
    bundleId: appBundleId,
    deploymentTargets: deploymentTarget,
    infoPlist: .extendingDefault(with: infoPlist),
    dependencies: [
        .package(product: "ComposableArchitecture")
    ],
    settings: .settings(
        base: [
            "DEFINES_MODULE": "NO"
        ]
    )
)

let tcaURL = "https://github.com/pointfreeco/swift-composable-architecture.git"
let tcaVersion: Package.Requirement = .upToNextMajor(from: "1.17.0")


let project = Project(
    name: appName,
    organizationName: "Page",
    packages: [
        .remote(url: tcaURL, requirement: tcaVersion)
    ],
    targets: [target]
)

