//
//  Dependencies.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/29.
//

import ProjectDescription

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: .init([
        .moya,
        .swiftyJSON,
        .kingfisher,
        .firebaseSdk,
        .tca,
        .googleMobileAds
    ]),
    platforms: [.iOS]
)

public extension Package {
    static let moya: Package = .remote(url: "https://github.com/Moya/Moya.git", requirement: .branch("master"))
    static let swiftyJSON: Package = .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .branch("master"))
    static let kingfisher: Package = .remote(url: "https://github.com/onevcat/Kingfisher.git", requirement: .branch("master"))
    static let firebaseSdk: Package = .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .upToNextMajor(from: "10.9.0"))
    static let tca: Package = .remote(url: "https://github.com/pointfreeco/swift-composable-architecture.git", requirement: .branch("main"))
    static let googleMobileAds: Package = .remote(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", requirement: .branch("main"))
}
