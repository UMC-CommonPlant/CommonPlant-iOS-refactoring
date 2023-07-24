//
//  MainViewModel.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/18.
//

import Foundation
import RxSwift

struct MainViewModel {
    var mainObservable = BehaviorSubject<[MainModel]>(value: [])
    
    init() {
        let samplePlace1 = Place(placeImage: "place1", placeName: "카페")
        let samplePlace2 = Place(placeImage: "place2", placeName: "도서관")
        let samplePlace3 = Place(placeImage: "place3", placeName: "공원")
        let samplePlace4 = Place(placeImage: "place4", placeName: "회사")

        let samplePlant1 = Plant(plantImage: "plant1", plantName: "무")
        let samplePlant2 = Plant(plantImage: "plant2", plantName: "보스턴고사리")
        let samplePlant3 = Plant(plantImage: "plant3", plantName: "안개꽃")
        let samplePlant4 = Plant(plantImage: "plant4", plantName: "핑크로즈")
        let samplePlant5 = Plant(plantImage: "plant5", plantName: "보스턴고사리")
        let samplePlant6 = Plant(plantImage: "plant6", plantName: "안개꽃")

        var mainModel = MainModel(userName: "커먼", placeList: [samplePlace1, samplePlace2, samplePlace3, samplePlace4], plantList: [samplePlant1, samplePlant2, samplePlant3, samplePlant4, samplePlant5, samplePlant6])
        
        if mainModel.placeList.isEmpty {
            let defaultPlace = Place(placeImage: "addPlaceCellFirstImage", placeName: "")
            mainModel.placeList = [defaultPlace]
        }
        
        if mainModel.plantList.isEmpty {
            let defaultPlant = Plant(plantImage: "addPlantCellFirstImage", plantName: "")
            mainModel.plantList = [defaultPlant]
        }
        mainObservable.onNext([mainModel])
    }
    
    
}


