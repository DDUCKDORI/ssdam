//
//  APIClient.swift
//  Domain
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Alamofire
import Combine
import CombineMoya
import Foundation
import Moya

public final class APIClient: MoyaProvider<MultiTarget> {
    public init() {
        let plugins = NetworkAuthPlugins.shared.fetchPlugins()
        let responseCacher = ResponseCacher(behavior: .modify { _, response in
            let userInfo = ["date": Date()]
            return CachedURLResponse(
                response: response.response,
                data: response.data,
                userInfo: userInfo,
                storagePolicy: .allowed)
        })

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 5
        sessionConfig.waitsForConnectivity = true
        sessionConfig.requestCachePolicy = .returnCacheDataElseLoad

        let session = Session(configuration: sessionConfig,
                              startRequestsImmediately: true)

        super.init(session: session, plugins: plugins)
    }

    public func request(router: TargetType) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(.target(router)) { result in
                continuation.resume(returning: result)
            }
        }
    }

    public func nullableResponseRequest(router: TargetType) -> AnyCancellable {
        self.requestPublisher(.target(router), callbackQueue: .main)
            .filter(statusCodes: 200 ..< 500)
            .retry(3)
            .subscribe(on: DispatchQueue.global())
            .sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
}


extension MoyaProvider {
    func request(_ target: Target) async -> Result<Response, MoyaError> {
        await withCheckedContinuation { continuation in
            self.request(target) { result in
                continuation.resume(returning: result)
            }
        }
    }
}
