//
//  PlantService.swift
//  CommonPlant
//
//  Created by 아라 on 5/15/24.
//

import Foundation
import Moya

enum PlantService {
    case searchPlant(name: String)
}

extension PlantService: BaseTargetType {
    var path: String {
        switch self {
        case .searchPlant(_):
            URLConstant.searchPlant
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .searchPlant(_):
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .searchPlant(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .searchPlant(_):
            return NetworkConstant.noHeader
        }
    }
}
