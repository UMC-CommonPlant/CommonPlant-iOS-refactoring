//
//  KakaoResponse.swift
//  CommonPlant
//
//  Created by 아라 on 4/8/24.
//

import Foundation

struct KakaoResponse: Codable {
    let timeStamp: String
    let status: Int
    let message, result: String
    let success: Bool
}
