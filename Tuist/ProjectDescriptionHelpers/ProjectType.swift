//
//  ProjectType.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/30.
//

import ProjectDescription

public enum Module: CaseIterable {
    case app
    case domain
    case data
    case utils
    case network
//    case designSystem
}

public extension Module {
    var name: String {
        switch self {
        case .app: return "ggugeApp"
        case .domain: return "Domain"
        case .data: return "Data"
        case .utils: return "Utils"
        case .network: return "Networking"
//        case .designSystem: return "DesignSystem"
        }
    }

    var path: ProjectDescription.Path {
        .relativeToRoot(self.name)
    }

    var project: TargetDependency {
        .project(target: self.name, path: self.path)
    }
}
