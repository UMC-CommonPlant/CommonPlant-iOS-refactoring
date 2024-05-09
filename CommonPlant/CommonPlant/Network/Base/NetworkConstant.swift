//
//  NetworkConstant.swift
//  CommonPlant
//
//  Created by 아라 on 5/7/24.
//

import Foundation

struct NetworkConstant {
    static let noHeader: [String : String]? = nil
    static let hasMultipartHeader = ["Content-Type" : "multipart/form-data"]
    static var hasTokenHeader: [String: String] {
        let token = try! KeychainManager.read()
        
        return ["X-AUTH-TOKEN": token]
    }
}
