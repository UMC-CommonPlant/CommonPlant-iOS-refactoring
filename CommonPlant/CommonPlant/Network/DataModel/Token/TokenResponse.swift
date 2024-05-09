//
//  TokenResponse.swift
//  CommonPlant
//
//  Created by 아라 on 5/5/24.
//

import Foundation

struct TokenResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let result, success: Bool
}
