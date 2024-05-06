// swift-tools-version:5.9

import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .staticFramework,
            "FirebaseAnalytics": .staticLibrary,
            "GoogleMobileAds": .staticLibrary,
            "Moya": .staticLibrary,
            "CombineMoya": .staticLibrary,
            "Alamofire": .staticLibrary,
            "SwiftyJSON": .staticLibrary
            
        ],
        // To revert once we release Tuist 4
        targetSettings: [:
//            "Mockable": ["ENABLE_TESTING_SEARCH_PATHS": "YES"],
//            "MockableTest": ["ENABLE_TESTING_SEARCH_PATHS": "YES"],
        ]
    )

#endif

let package = Package(
    name: "Ssdam",
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", branch: "main"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", branch: "master"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk", branch: "main"),
        .package(url: "https://github.com/Moya/Moya.git", branch: "master"),
        .package(url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git", branch: "main"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", branch: "master")
    ]
)
