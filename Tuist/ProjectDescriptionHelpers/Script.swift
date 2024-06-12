//
//  Script.swift
//  ProjectDescriptionHelpers
//
//  Created by 김재민 on 6/11/24.
//

import ProjectDescription

public extension TargetScript {
    static var crashlytics: TargetScript = .post(
        path: .relativeToRoot(".build/checkouts/firebase-ios-sdk/Crashlytics/run"),
        name: "Crashlytics",
        inputPaths: [
            "${DWARF_DSYM_FOLDER_PATH}/${DWARF_DSYM_FILE_NAME}/Contents/Resources/DWARF/${TARGET_NAME}",
            "$(SRCROOT)/$(BUILT_PRODUCTS_DIR)/$(INFOPLIST_PATH)",
        ],
        basedOnDependencyAnalysis: true)
}
