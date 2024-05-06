//
//  TokenService.swift
//  CommonPlant
//
//  Created by 아라 on 5/5/24.
//

import Foundation
import Moya

enum TokenService {
    case getTokenAvailability(token: String?)
}

extension TokenService: TargetType {
    var baseURL: URL {
        guard let baseString = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String,
              let baseURL = URL(string: baseString) else { fatalError("유효하지 않는 서버 URL입니다.") }
        
        return baseURL
    }
    
    var path: String {
        switch self {
        case .getTokenAvailability(_):
            "/api/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTokenAvailability(_) :
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getTokenAvailability :
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .getTokenAvailability(token):
            guard let token = token else { return nil }
            
            return ["X-AUTH-TOKEN" : token]
        }
    }
}
