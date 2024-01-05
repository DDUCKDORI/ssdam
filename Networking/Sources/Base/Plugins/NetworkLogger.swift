//
//  NetworkLogger.swift
//  Networking
//
//  Created by Jimmy on 2023/10/30.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation
import Moya
import SwiftUI
import Utils

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
        
        switch result {
        case let .success(response):
            onSuceed(response, target: target, isFromError: false)
        case .failure(let error):
            onFail(error, target: target)
        }
    }
    func onSuceed(_ response: Response, target: TargetType, isFromError: Bool) {
        let request = response.request
        let url = request?.url?.absoluteString ?? "nil"
        let statusCode = response.statusCode
        
        var log = "------------------- SUCCESS (isFromError: \(isFromError)) -------------------"
        log.append("\n[\(statusCode)] \(url)\n----------------------------------------------------\n")
        log.append("API: \(target)\n")
//        response.response?.allHeaderFields.forEach {
//            log.append("\($0): \($1)\n")
//        }
//        if let reString = String(bytes: response.data, encoding: String.Encoding.utf8) {
//            log.append("\(reString)\n")
//        }
////        log.append("------------------- END HTTP (\(response.data.count)-byte body) -------------------")
        print(log)
        
        // 🔥 in case of 401.
        switch statusCode {
        case 401:
            reissueAccessToken(request: TokenInfo(accessToken: Const.accessToken, refreshToken: Const.refreshToken))
            
        default:
            return
        }
    }
    func onFail(_ error: MoyaError, target: TargetType) {
        if let response = error.response {
            onSuceed(response, target: target, isFromError: true)
            return
        }
        var log = "네트워크 오류"
        log.append("<-- \(error.errorCode) \(target)\n")
        log.append("\(error.failureReason ?? error.errorDescription ?? "unknown error")\n")
        log.append("<-- END HTTP")
        print(log)
    }
}

extension NetworkLogger {
    func reissueAccessToken(request: TokenInfo) {
        let provider = MoyaProvider<AuthAPI>()
//        provider.request(.fetchAccessCode(request)) { result in
//            switch result {
//            case .success(let response):
//                let decoder = JSONDecoder()
//                // reissue access token
//                if let tokenData = try? decoder.decode(TokenInfo.self, from: response.data) {
//                    UserDefaults.standard.set(tokenData.accessToken, forKey: "accessToken")
//                    UserDefaults.standard.set(tokenData.refreshToken, forKey: "refreshToken")
//                    
//                    print("userTokenReissueWithAPI - success")
//                }
//            case .failure(let error):
//                // in case of invalide refresh token
//                if let statusCode = error.response?.statusCode, statusCode == 406 {
//                    
//                    UserDefaults.standard.removeObject(forKey: "accessToken")
//                    UserDefaults.standard.removeObject(forKey: "refreshToken")
//                    //                    UserDefaults.standard.removeObject(forKey: Const.userID)
//                    print("error - statusCode: \(statusCode)")
//                }
//            }
//        }
    }
}
