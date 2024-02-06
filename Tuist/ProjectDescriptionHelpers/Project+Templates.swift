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
    static let kingfisher: TargetDependency = .external(name: "Kingfisher")
    static let firebaseRemoteConfig: TargetDependency = .external(name: "FirebaseRemoteConfig")
    static let firebaseAnalytics: TargetDependency = .external(name: "FirebaseAnalytics")
    static let firebaseDynamicLinks: TargetDependency = .external(name: "FirebaseDynamicLinks")
    static let firebaseCrashlytics: TargetDependency = .external(name: "FirebaseCrashlytics")
    static let tca: TargetDependency = .external(name: "ComposableArchitecture")
    static let googleMobileAds: TargetDependency = .external(name: "GoogleMobileAds")
}

extension Project {
    /// Helper function to create the Project for this ExampleApp
    public static func app(name: String, platform: Platform, dependencies: [TargetDependency], additionalTargets: [String]) -> Project {
        var targets = makeAppTargets(name: name,
                                     platform: platform,
                                     dependencies: dependencies)
        
        return Project(name: name,
                       organizationName: "com.dduckdori",
//                       options: .options(
//                        disableBundleAccessors: true,
//                        disableSynthesizedResourceAccessors: true
//                       ),
                       targets: targets)
    }

    // MARK: - Private

    /// Helper function to create a framework target and an associated unit test target
    private static func makeFrameworkTargets(name: String, platform: Platform) -> [Target] {
        let sources = Target(name: name,
                platform: platform,
                product: .framework,
                bundleId: "com.dduckdori.\(name)",
                infoPlist: .default,
                sources: ["Targets/\(name)/Sources/**"],
                resources: ["Resources/LaunchScreen.storyboard"],
                entitlements: .relativeToRoot("\(Module.app.name)/Entitlements/Ssdam.entitlements"),
                dependencies: [])
        let tests = Target(name: "\(name)Tests",
                platform: platform,
                product: .unitTests,
                bundleId: "com.dduckdori.\(name)Tests",
                infoPlist: "Config/SsdamTest-Info.plist",
                sources: ["Tests/**"],
                resources: [],
                dependencies: [.target(name: name)])
        return [sources, tests]
    }

    /// Helper function to create the application target and the unit test target.
    private static func makeAppTargets(name: String, platform: Platform, dependencies: [TargetDependency]) -> [Target] {
        let platform: Platform = platform
//        let infoPlist: [String: InfoPlist.Value] = [
//            "CFBundleShortVersionString": "1.0",
//            "CFBundleVersion": "1",
//            "UIMainStoryboardFile": "",
//            "UILaunchStoryboardName": "LaunchScreen"
//            ]

        let mainTarget = Target(
            name: name,
            platform: platform,
            product: .app,
            bundleId: "com.dduckdori.\(name)",
            deploymentTarget: .iOS(targetVersion: "16.4", devices: [.iphone, .ipad]),
            infoPlist: "Config/Ssdam-Info.plist",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .relativeToRoot("\(Module.app.name)/Entitlements/Ssdam.entitlements"),
            dependencies: dependencies
        )

        let testTarget = Target(
            name: "\(name)Tests",
            platform: platform,
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
            Target(
                name: name,
                platform: .iOS,
                product: .framework,
                bundleId: "\(organizationName).\(name)",
                deploymentTarget: .iOS(targetVersion: "15.0",
                                       devices: [.iphone]),
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
