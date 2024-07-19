//
//  HistoryService.swift
//  CommonPlant
//
//  Created by 이예원 on 7/8/24.
//

import Foundation
import Moya

enum HistoryService {
    case fetchWordList
}

extension HistoryService: BaseTargetType {
    var path: String {
        return URLConstant.fetchWordList
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Moya.Task {
        return .requestPlain
    }
    
    var headers: [String : String]? {
        return NetworkConstant.noHeader
    }
}
