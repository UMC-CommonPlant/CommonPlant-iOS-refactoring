//
//  PlantDetailResponse.swift
//  CommonPlant
//
//  Created by 아라 on 6/3/24.
//

import Foundation

struct PlantDetailResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let result: PlantDetail
    let success: Bool
}

struct PlantDetail: Codable {
    let plantIdx: Int
    let name, nickname, place: String
    let imgURL: String
    let countDate, remainderDate: Int
    let memoList: [PlantMemo]
    let scientificName: String
    let waterDay: Int
    let sunlight: String
    let tempMin, tempMax: Int
    let humidity, createdAt, wateredDate: String

    enum CodingKeys: String, CodingKey {
        case plantIdx, name, nickname, place
        case imgURL = "imgUrl"
        case countDate, remainderDate, memoList, scientificName, waterDay, sunlight, tempMin, tempMax, humidity, createdAt, wateredDate
    }
}

struct PlantMemo: Codable {
    let memoIdx: Int
    let content: String
    let imgURL: String
    let writer, createdAt: String

    enum CodingKeys: String, CodingKey {
        case memoIdx = "memo_idx"
        case content
        case imgURL = "imgUrl"
        case writer
        case createdAt = "created_at"
    }
}
