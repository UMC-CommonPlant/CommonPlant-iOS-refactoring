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
