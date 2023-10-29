//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/29.
//

import ProjectDescription

let dependencies = Dependencies(
    swiftPackageManager: [
        .remote(url: "https://github.com/Alamofire/Alamofire", requirement: .upToNextMajor(from: "5.0.0")),
    ],
    platforms: [.iOS]
)
