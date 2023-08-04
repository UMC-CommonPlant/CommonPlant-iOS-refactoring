//
//  PlantSearchViewModel.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/31.
//

import Foundation
import RxSwift

struct PlantSearchViewModel {
    var plantSearchObservable = BehaviorSubject<[PoplularSearchModel]>(value: [])
    
    init() {
        let sampleData1 = PoplularSearchModel(plantImage: "plant1", plantName: "몬스테라", scientificName: "Monstera deliciosa", searchCount: 100)
        let sampleData2 = PoplularSearchModel(plantImage: "plant2", plantName: "카스테라", scientificName: "Monstera deliciosa", searchCount: 200)
        let sampleData3 = PoplularSearchModel(plantImage: "plant3", plantName: "카스", scientificName: "Monstera deliciosa", searchCount: 300)
        let sampleData4 = PoplularSearchModel(plantImage: "plant4", plantName: "테라", scientificName: "Monstera deliciosa", searchCount: 400)
        let sampleData5 = PoplularSearchModel(plantImage: "plant1", plantName: "몬스테라", scientificName: "Monstera deliciosa", searchCount: 100)
        let sampleData6 = PoplularSearchModel(plantImage: "plant2", plantName: "카스테라", scientificName: "Monstera deliciosa", searchCount: 200)
        let sampleData7 = PoplularSearchModel(plantImage: "plant3", plantName: "카스", scientificName: "Monstera deliciosa", searchCount: 300)
        let sampleData8 = PoplularSearchModel(plantImage: "plant4", plantName: "테라", scientificName: "Monstera deliciosa", searchCount: 400)
        let sampleData9 = PoplularSearchModel(plantImage: "plant1", plantName: "몬스테라", scientificName: "Monstera deliciosa", searchCount: 100)
        let sampleData10 = PoplularSearchModel(plantImage: "plant2", plantName: "카스테라", scientificName: "Monstera deliciosa", searchCount: 200)
        
        let plantSearchModel = [sampleData1, sampleData2, sampleData3, sampleData4, sampleData5, sampleData6, sampleData7, sampleData8,sampleData9, sampleData10]
        plantSearchObservable.onNext(plantSearchModel)
    }
}
