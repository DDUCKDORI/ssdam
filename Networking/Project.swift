//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Jimmy on 2023/10/30.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.module(
    name: Module.network.name,
    dependencies: [.moya, .combineMoya],
    additionalTargets: []
)
