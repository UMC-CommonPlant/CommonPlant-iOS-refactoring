//
//  PutPlantResponse.swift
//  CommonPlant
//
//  Created by 아라 on 6/25/24.
//

import Foundation

struct PutPlantResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let success: Bool
}
