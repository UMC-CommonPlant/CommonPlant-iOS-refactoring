//
//  HistoryResponse.swift
//  CommonPlant
//
//  Created by 이예원 on 7/8/24.
//

import Foundation

struct HistoryResponse: Codable {
    let timeStamp: String
    let status: Int
    let message: String
    let result: WordListResult
    let success: Bool
}

struct WordListResult: Codable {
    let firstDayOfMonth: String
    let historyDtoList: [HistoryDto]
}

struct HistoryDto: Codable {
    let name: String
    let scientificName: String
    let imgUrl: String
    let count: Int
    
    enum CodingKeys: String, CodingKey {
        case name
        case scientificName = "scientific_name"
        case imgUrl
        case count
    }
}
