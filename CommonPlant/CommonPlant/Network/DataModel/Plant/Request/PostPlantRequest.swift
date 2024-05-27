//
//  PostPlantRequest.swift
//  CommonPlant
//
//  Created by 아라 on 5/27/24.
//

import Foundation

struct PostPlantRequest: Codable {
    let plantName, nickname, place, waterCycle: String
    let lastWateredDate: String
    let imageData: Data?
}
