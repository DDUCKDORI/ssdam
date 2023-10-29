import ProjectDescription
import ProjectDescriptionHelpers
import MyPlugin

/*
                +-------------+
                |             |
                |     App     | Contains Ssdam App target and Ssdam unit-test target
                |             |
         +------+-------------+-------+
         |         depends on         |
         |                            |
 +----v-----+                   +-----v-----+
 |          |                   |           |
 |   Kit    |                   |     UI    |   Two independent frameworks to share code and start modularising your app
 |          |                   |           |
 +----------+                   +-----------+

 */

// MARK: - Project

// Local plugin loaded
let localHelper = LocalHelper(name: "MyPlugin")

// Creates our project using a helper function defined in ProjectDescriptionHelpers
let project = Project(
    name: "Ssdam",
    organizationName: "tuist.io",
    targets: [
        Target(
            name: "Ssdam",
            platform: .iOS,
            product: .app,
            bundleId: "io.tuist.Ssdam",
            deploymentTarget: .iOS(targetVersion: "16.4", devices: .iphone),
            infoPlist: .default,
            sources: ["Targets/Ssdam/Sources/**"],
            resources: ["Targets/Ssdam/Resources/**"],
            dependencies: [
                .external(name: "Alamofire"),
            ]
        ),
    ]
)
