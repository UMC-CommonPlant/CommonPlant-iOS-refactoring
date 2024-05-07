//
//  TokenService.swift
//  CommonPlant
//
//  Created by 아라 on 5/5/24.
//

import Foundation
import Moya

enum TokenService {
    case getTokenAvailability
}

extension TokenService: BaseTargetType {
    var path: String {
        switch self {
        case .getTokenAvailability:
            URLConstant.getTokenAvailability
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getTokenAvailability :
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
        case .getTokenAvailability:
            return NetworkConstant.hasTokenHeader
        }
    }
}
