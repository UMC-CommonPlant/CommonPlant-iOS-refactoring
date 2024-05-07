//
//  BaseTargetType.swift
//  CommonPlant
//
//  Created by 아라 on 5/7/24.
//

import Foundation
import Moya

protocol BaseTargetType: TargetType { }

extension BaseTargetType {
    var baseURL: URL {
        guard let baseURL = URL(string: URLConstant.baseURL) else { fatalError("유효하지 않은 BaseURL입니다.") }
        return baseURL
    }
}
