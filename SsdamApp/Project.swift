//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
    name: "Ssdam",
    platform: .iOS,
    dependencies: [
        .kingfisher,
        .firebaseAnalytics,
        .firebaseCrashlytics,
        .firebaseDynamicLinks,
        .firebaseRemoteConfig,
        .tca
    ] + [Module.data, Module.domain, Module.network].map(\.project), additionalTargets: [])
