//
//  LoginService.swift
//  CommonPlant
//
//  Created by 아라 on 4/8/24.
//

import Foundation
import Moya

enum LoginService {
    case kakaoLogin(token: String)
    case appleLogin(token: String)
}

extension LoginService: BaseTargetType {
    var path: String {
        switch self {
        case .kakaoLogin:
            URLConstant.kakaoLogin
        case .appleLogin:
            URLConstant.appleLogin
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        switch self {
        case .kakaoLogin(let token), .appleLogin(let token) :
            return .requestParameters(parameters: ["accessToken": token], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstant.noHeader
    }
}
