//
//  DeletePlantResponse.swift
//  CommonPlant
//
//  Created by 아라 on 7/7/24.
//

import Foundation

struct DeletePlantResponse: Codable {
    let timeStamp: String
    let status: Int
    let message, result: String
    let success: Bool
}
