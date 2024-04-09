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

extension LoginService: TargetType {
    var baseURL: URL {
        guard let baseString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let baseURL = URL(string: baseString) else { fatalError("유효하지 않는 서버 URL입니다.") }
        
        return baseURL
    }
    
    var path: String {
        switch self {
        case .kakaoLogin:
            "/login/kakao"
        case .appleLogin:
            "/login/apple"
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
        return nil
    }
}
