//
//  PostPlantResponse.swift
//  CommonPlant
//
//  Created by 아라 on 5/27/24.
//

import Foundation

struct PostPlantResponse: Codable {
    let timeStamp: String
    let status: Int
    let message, result: String
    let success: Bool
}
