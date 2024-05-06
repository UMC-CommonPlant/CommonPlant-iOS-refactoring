//
//  PostUserResponse.swift
//  CommonPlant
//
//  Created by 아라 on 4/22/24.
//

import Foundation

struct PostUserResponse: Codable {
    let timeStamp: String
    let status: Int
    let message, result: String
    let success: Bool
}
