//
//  URLConstant.swift
//  CommonPlant
//
//  Created by 아라 on 5/7/24.
//

import Foundation

struct URLConstant {
    static let baseURL: String = {
        guard let baseURL = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String else { fatalError("BASE_URL not found in Info.plist") }
        return baseURL
    }()
    
    // MARK: Token
    static let getTokenAvailability = "/api/token"
    
    // MARK: Login
    static let kakaoLogin = "/login/kakao"
    static let appleLogin = "/login/apple"
    
    // MARK: User
    static let postUser = "/user"
    static let getDuplicateNickname = "/user"
    
    // MARK: Plant
    static let placeList = "/place/user"
    
    // MARK: Info
    static let searchPlantWithWaterDay = "/info/searchInfoPlus"
}
