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
    destinations: [.iPhone, .iPad],
    dependencies: [
//        .kingfisher,
        .firebaseAnalytics,
//        .firebaseCrashlytics,
//        .firebaseDynamicLinks,
//        .firebaseRemoteConfig,
        .tca,
        .googleMobileAds
    ] + [Module.data, Module.domain, Module.network, Module.utils].map(\.project), additionalTargets: [])
