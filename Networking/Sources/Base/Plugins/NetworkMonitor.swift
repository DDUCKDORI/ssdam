//
//  NetworkMonitor.swift
//  Networking
//
//  Created by 김재민 on 1/25/24.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import Alamofire

public struct NetworkMonitor {
    public static let shared = NetworkMonitor()

    private let reachabilityManager: NetworkReachabilityManager?

    private init() {
        reachabilityManager = NetworkReachabilityManager()
    }

    public var isReachable: Bool {
        reachabilityManager?.isReachable ?? true
    }

    public func startNetworkMonitoring(completion: @escaping (_ status: NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        reachabilityManager?.startListening {
            completion($0)
        }
    }
    public func stopNetworkMonitoring(completion: @escaping (_ status: NetworkReachabilityManager.NetworkReachabilityStatus) -> Void) {
        reachabilityManager?.stopListening()
    }
}
