//
//  GetDuplicateNicknameResponse.swift
//  CommonPlant
//
//  Created by 아라 on 4/17/24.
//

import Foundation

struct GetDuplicateNicknameResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let result, success: Bool
}
