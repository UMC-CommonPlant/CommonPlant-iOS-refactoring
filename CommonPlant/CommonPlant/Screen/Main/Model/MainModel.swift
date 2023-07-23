//
//  MyGardenModel.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/19.
//

import Foundation

struct MainModel {
    var userName: String
    var placeList: [Place]
    var plantList: [Plant]
}

struct Place {
    var placeImage: String
    var placeName: String
}

struct Plant {
    var plantImage: String
    var plantName: String
}
