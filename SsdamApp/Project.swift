//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Ssdam",
    organizationName: "com.dduckdori", options: .options(disableBundleAccessors: true, disableSynthesizedResourceAccessors: true),
    targets: [
        Target(
            name: "Ssdam",
            platform: .iOS,
            product: .app,
            bundleId: "com.dduckdori.Ssdam",
            deploymentTarget: .iOS(targetVersion: "16.4", devices: .iphone),
            infoPlist: "Config/Ssdam-Info.plist",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .relativeToRoot("SsdamApp/Entitlements/Ssdam.entitlements"),
            dependencies: [
                .kingfisher,
                .firebaseAnalytics,
                .firebaseCrashlytics,
                .firebaseDynamicLinks,
                .firebaseRemoteConfig,
                .tca
            ] + [Module.data, Module.domain, Module.network].map(\.project)
        ),
    ]
)
 
