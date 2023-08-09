//
//  SearchResultViewModel.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/08/08.
//

import Foundation
import RxSwift

struct SearchResultViewModel {
    var searchResultObservable = BehaviorSubject<[SearchResultModel]>(value: [])
    var searchResultModel: [SearchResultModel]
    
    init() {
        let sampleData1 = SearchResultModel(plantImage: "plant1", plantName: "몬스테라", scientificName: "Monstera deliciosa")
        let sampleData2 = SearchResultModel(plantImage: "plant2", plantName: "몬카스테라", scientificName: "Monstera deliciosa")
        let sampleData3 = SearchResultModel(plantImage: "plant3", plantName: "카스", scientificName: "Monstera deliciosa")
        let sampleData4 = SearchResultModel(plantImage: "plant4", plantName: "테라", scientificName: "Monstera deliciosa")
        
        searchResultModel = [sampleData1, sampleData2, sampleData3, sampleData4]
    }
    
    func searchPlants(_ query: String) {
        let filteredPlants = searchResultModel.filter { plant in
            plant.plantName.lowercased().contains(query.lowercased()) ||
            plant.scientificName.lowercased().contains(query.lowercased())
        }
        searchResultObservable.onNext(filteredPlants)
    }
}
