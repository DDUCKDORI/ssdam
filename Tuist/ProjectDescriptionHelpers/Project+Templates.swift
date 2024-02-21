import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

import ProjectDescription

public extension TargetDependency {
    static let moya: TargetDependency = .external(name: "Moya")
    static let combineMoya: TargetDependency = .external(name: "CombineMoya")
    static let swiftyJSON: TargetDependency = .external(name: "SwiftyJSON")
//    static let firebaseRemoteConfig: TargetDependency = .external(name: "FirebaseRemoteConfig")
    static let firebaseAnalytics: TargetDependency = .external(name: "FirebaseAnalytics")
//    static let firebaseDynamicLinks: TargetDependency = .external(name: "FirebaseDynamicLinks")
//    static let firebaseCrashlytics: TargetDependency = .external(name: "FirebaseCrashlytics")
    static let tca: TargetDependency = .external(name: "ComposableArchitecture")
    static let googleMobileAds: TargetDependency = .external(name: "GoogleMobileAds")
}

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, destinations: Destinations, dependencies: [TargetDependency], additionalTargets: [String]) -> Project {
        let targets = makeAppTargets(name: name,
                                     destinations: destinations,
                                     dependencies: dependencies)
        
        return Project(name: name,
                       organizationName: "com.dduckdori",
//                       options: .options(
//                        disableBundleAccessors: true,
//                        disableSynthesizedResourceAccessors: true
//                       ),
                       targets: targets)
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, destinations: Destinations, dependencies: [TargetDependency]) -> [Target] {
        let destinations: Destinations = destinations
//        let infoPlist: [String: InfoPlist.Value] = [
//            "CFBundleShortVersionString": "1.0",
//            "CFBundleVersion": "1",
//            "UIMainStoryboardFile": "",
//            "UILaunchStoryboardName": "LaunchScreen"
//            ]

        let mainTarget = Target.target(
            name: name,
            destinations: destinations,
            product: .app,
            bundleId: "com.dduckdori.\(name)",
            deploymentTargets: .iOS("16.4"),
            infoPlist: "Config/Ssdam-Info.plist",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: "Entitlements/Ssdam.entitlements",
            dependencies: dependencies
        )

        let testTarget = Target.target(
            name: "\(name)Tests",
            destinations: destinations,
            product: .unitTests,
            bundleId: "com.dduckdori.\(name)Tests",
            infoPlist: "Config/SsdamTest-Info.plist",
            sources: ["Tests/**"],
            dependencies: [
                .target(name: "\(name)")
        ])
        return [mainTarget, testTarget]
    }
}

extension Project {
    static let organizationName = "com.dduckdori"
}

public extension Project {
    static func module(
        name: String,
        dependencies: [TargetDependency],
        additionalTargets: [String],
        resources: ProjectDescription.ResourceFileElements? = nil) -> Project {
//        let settings: Settings = makeAppSettings()

        let targets: [Target] = [
            Target.target(
                name: name,
                destinations: [.iPhone, .iPad],
                product: .framework,
                bundleId: "\(organizationName).\(name)",
                deploymentTargets: .iOS("16.4"),
                infoPlist: .default,
                sources: ["Sources/**"],
                resources: resources,
                dependencies: dependencies
//                settings: settings
            )
        ]

//        let schemes: [Scheme] = [
//            Scheme(
//                name: "\(name)",
//                shared: true,
//                buildAction: .buildAction(targets: [".\(name)"]),
//                testAction: .targets(["\(name)Tests"]),
//                runAction: .runAction(configuration: .debug,
//                                      executable: "\(name)"),
//                archiveAction: .archiveAction(configuration: .debug))
//        ]

        return Project(name: name,
                       organizationName: organizationName,
//                       settings: settings,
                       targets: targets
//                       schemes: schemes
        )
    }
}
