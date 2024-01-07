//
//  BackendError.swift
//  Domain
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import Moya
import SwiftyJSON

public struct BackendError: Decodable, Error {
    public var status: String
    public var message: String

    public init() {
        status = ""
        message = ""
    }

    public init(json: JSON) {
        status = json["result"].stringValue
        message = json["message"].stringValue
    }
}

public extension MoyaError {
    var backendError: BackendError {
        response
            .flatMap { try? JSON(data: $0.data) }
            .map { BackendError(json: $0) } ?? BackendError()
    }
}
