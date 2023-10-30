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
    organizationName: "com.dduckdori",
    targets: [
        Target(
            name: "Ssdam",
            platform: .iOS,
            product: .app,
            bundleId: "com.dduckdori.Ssdam",
            deploymentTarget: .iOS(targetVersion: "16.4", devices: .iphone),
            infoPlist: .default,
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .kingfisher,
                .firebaseAnalytics,
                .firebaseCrashlytics,
                .firebaseDynamicLinks,
                .firebaseRemoteConfig
            ] + [Module.data, Module.domain, Module.network].map(\.project)
        ),
    ]
)
