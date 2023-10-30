//
//  Workspace.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(
    name: "Ssdam",
    projects: Module.allCases.map(\.path)
)
