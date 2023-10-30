//
//  NetworkLogger.swift
//  Networking
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import Moya

/// CUSTOM Newtork Logger
final class NetworkLogger: PluginType {
    /**
     Called immediately before a request is sent over the network (or stubbed).

     REQUEST Logger
     */
    func willSend(_ request: RequestType, target: TargetType) {
        let headers = request.request?.allHTTPHeaderFields ?? [:]
        let url = request.request?.url?.absoluteString ?? "☠️Nil"
        let path = url.replacingOccurrences(of: "\(target.baseURL)", with: "")
        if let body = request.request?.httpBody {
            let bodyString = String(bytes: body, encoding: String.Encoding.utf8) ?? "☠️Nil"
            print("""
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
                  <willSend - \(path) \(Date().debugDescription)>
                  url: \(url)
                  headers : \(headers)
                  body: \(bodyString)
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
            """)
        } else {
            print("""
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
                  <willSend - \(path) \(Date().debugDescription)>
                  url: \(url)
                  headers : \(headers)
                  body: nil
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
            """)
        }
    }

    /**
     Called after a response has been received, but before the MoyaProvider has invoked its completion handler.

     RESPONSE Logger
     */
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        let response = try? result.get()
        let request = response?.request

        let url = request?.url?.absoluteString ?? "Nil"
        let method = request?.httpMethod ?? "Nil"
        let statusCode = response?.statusCode ?? 0
        var bodyString = "Nil"
        if let data = (request?.httpBody), let string = String(bytes: data, encoding: String.Encoding.utf8) {
            bodyString = string
        }
        var responseString = "Nil"
        if let data = response?.data, let reString = String(bytes: data, encoding: String.Encoding.utf8) {
            responseString = reString
        }

        switch result {
        case .success:
            print("""
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
                <didReceive - \(method) statusCode: \(statusCode)>
                url: \(url)
                body: \(bodyString)
                response: \(responseString)
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
            """)
        case .failure(let error):
            print("""
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
                <didReceive - \(method) statusCode: \(statusCode)>
                url: \(url)
                body: \(bodyString)
                error: \(error.localizedDescription)")
                response: \(responseString)
                ◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
            """)
        }
    }
}
