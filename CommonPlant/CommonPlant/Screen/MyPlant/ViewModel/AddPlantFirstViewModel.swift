//
//  AddPlantFirstViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 1/19/24.
//

import Foundation
import RxSwift
import RxCocoa

class AddPlantFirstViewModel {
    let disposeBag = DisposeBag()
    var searchResultList = BehaviorRelay<[SearchResultModel]>(value: [])
    
    init() {
        let sampleData1 = SearchResultModel(plantImage: "plant1", plantName: "몬스테라", scientificName: "Monstera deliciosa")
        let sampleData2 = SearchResultModel(plantImage: "plant2", plantName: "몬카스테라", scientificName: "Monstera deliciosa")
        let sampleData3 = SearchResultModel(plantImage: "plant3", plantName: "카스", scientificName: "Monstera deliciosa")
        let sampleData4 = SearchResultModel(plantImage: "plant4", plantName: "테라", scientificName: "Monstera deliciosa")
        
        let list = [sampleData1, sampleData2, sampleData3, sampleData4]
        
        searchResultList.accept(list)
    }
    
    struct Input {
        let searchBtnDidTap: Observable<String>
        let selectedPlant: Observable<IndexPath>
    }
    
    struct Output {
        let transigionNextStep: Driver<SearchResultModel>
    }
    
    func transform(input: Input) -> Output {
        let selectedPlant = PublishRelay<SearchResultModel>()
        
        input.searchBtnDidTap.bind { plant in
            // TODO: API 연동 및 searchResultList 업데이트
        }.disposed(by: disposeBag)
        
        input.selectedPlant.bind { [ weak self ] indexPath in
            guard let self = self else { return }
            let plant = self.searchResultList.value[indexPath.row]
            
            selectedPlant.accept(plant)
        }.disposed(by: disposeBag)
        
        return Output(transigionNextStep: selectedPlant.asDriver(onErrorJustReturn: SearchResultModel(plantImage: "", plantName: "", scientificName: "")))
    }
}
