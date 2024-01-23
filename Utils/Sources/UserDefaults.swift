//
//  UserDefaults.swift
//  Ssdam
//
//  Created by 김재민 on 2023/12/08.
//  Copyright © 2023 com.dduckdori. All rights reserved.
//

import Foundation

@propertyWrapper
public struct UserDefault<T> {
    public let key: String
    public let defaultValue: T
    public let storage: UserDefaults
    
    public var wrappedValue: T {
        get { self.storage.object(forKey: self.key) as? T ?? self.defaultValue }
        set { self.storage.set(newValue, forKey: self.key) }
    }
    
    public init(key: String, defaultValue: T, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }
}

public enum Const {
    /// access token
    @UserDefault(key: "accessToken", defaultValue: "")
    public static var accessToken: String
    
    @UserDefault(key: "refreshToken", defaultValue: "")
    public static var refreshToken: String
    
    @UserDefault(key: "isUser", defaultValue: "")
    public static var isUser: String
    
    @UserDefault(key: "userType", defaultValue: "")
    public static var userType: String
    
    @UserDefault(key: "email", defaultValue: "")
    public static var email: String
    
    @UserDefault(key: "inviteCd", defaultValue: "")
    public static var inviteCd: String
    
    @UserDefault(key: "nickname", defaultValue: "")
    public static var nickname: String
    
    @UserDefault(key: "memId", defaultValue: -1)
    public static var memId: Int
    
    @UserDefault(key: "memSub", defaultValue: "")
    public static var memSub: String
    
    @UserDefault(key: "isPioneer", defaultValue: true)
    public static var isPioneer: Bool
    
    @UserDefault(key: "alreadySaved", defaultValue: false)
    public static var alreadySaved: Bool
}
