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
    case network
}

public extension Module {
    var name: String {
        switch self {
        case .app: return "SsdamApp"
        case .domain: return "Domain"
        case .data: return "Data"
        case .network: return "Networking"
        }
    }

    var path: ProjectDescription.Path {
        .relativeToRoot(self.name)
    }

    var project: TargetDependency {
        .project(target: self.name, path: self.path)
    }
}
