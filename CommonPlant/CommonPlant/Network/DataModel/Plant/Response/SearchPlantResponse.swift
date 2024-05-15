//
//  SearchPlantResponse.swift
//  CommonPlant
//
//  Created by 아라 on 5/15/24.
//

import Foundation

struct SearchPlantResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let result: [Result]
    let success: Bool
}

struct Result: Codable {
    let name, scientificName: String
    let imgURL: String

    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case imgURL = "imgUrl"
    }
}
