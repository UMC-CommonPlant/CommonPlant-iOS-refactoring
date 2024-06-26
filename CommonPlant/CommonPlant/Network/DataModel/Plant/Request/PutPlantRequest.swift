//
//  PutPlantRequest.swift
//  CommonPlant
//
//  Created by 아라 on 6/25/24.
//

import Foundation

struct PutPlantRequest: Codable {
    let plantIdx: Int
    let nickname: String
    let imageData: Data
}
