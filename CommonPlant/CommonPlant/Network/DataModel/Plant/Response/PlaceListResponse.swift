//
//  PlantPlaceListResponse.swift
//  CommonPlant
//
//  Created by 아라 on 5/27/24.
//

import Foundation

struct PlaceListResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let result: [PlaceListResult]
    let success: Bool
}

// MARK: - Result
struct PlaceListResult: Codable {
    let name: String
    let imgURL: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case name
        case imgURL = "imgUrl"
        case createdAt
    }
}
