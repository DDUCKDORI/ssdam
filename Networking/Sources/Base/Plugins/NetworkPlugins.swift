//
//  NetworkPlugins.swift
//  Domain
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import Moya

// abstract 플러그인
protocol MoyaPlugins: PluginType {
    func fetchPlugins() -> [PluginType]
}

// 공통 플러그인
extension MoyaPlugins {
    var networkLogger: NetworkLogger {
        NetworkLogger()
    }
}

// token 플러그인
class NetworkAuthPlugins: MoyaPlugins {
    internal var authPlugin: AccessTokenPlugin
    static let shared = NetworkAuthPlugins()

    private init() {
        authPlugin = AccessTokenPlugin { _ in
            // TODO: get access token
            ""
        }
    }

    func fetchPlugins() -> [PluginType] {
        [networkLogger, authPlugin]
    }
}

// 기본API 플러그인
class NetworkPlugins: MoyaPlugins {
    static let shared = NetworkPlugins()

    private init() {}

    func fetchPlugins() -> [PluginType] {
        [networkLogger]
    }
}
