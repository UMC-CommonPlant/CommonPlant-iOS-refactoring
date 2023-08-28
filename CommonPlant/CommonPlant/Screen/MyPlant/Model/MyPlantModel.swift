//
//  MyPlantModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/24.
//

import Foundation

struct MyPlant {
    let nickname, scientificName: String
    let place: String
    let imgURL: String
    let countDate, remainderDate: Int
    let createdAt, wateredDate: String
    let waterDay: Int
    let sunlight: String
    let tempMin, tempMax: Int
    let humidity: String
    let memoList: [Memo]
}

struct Memo {
    let userNickName: String
    let userImgURL: String
    let content: String
    let imgURL: String?
    let createdAt: String
}
