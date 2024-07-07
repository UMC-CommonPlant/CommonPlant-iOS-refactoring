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
    let searchResultList = BehaviorRelay<[SearchResult]>(value: [])
}

extension AddPlantFirstViewModel: ViewModelType {
    struct Input {
        let searchBtnDidTap: Observable<String>
        let selectedPlant: Observable<IndexPath>
    }
    
    struct Output {
        let transigionNextStep: Driver<SearchResult>
    }
    
    func transform(input: Input) -> Output {
        let selectedPlant = PublishRelay<SearchResult>()
        
        input.searchBtnDidTap.bind { plant in
            var plant = plant
            if let first = plant.first, first == " " {
                plant.removeFirst()
            }
            
            PlantAPI.shared.searchPlant(target: plant)
                .subscribe { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let response):
                        
                        searchResultList.accept(response.result)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        input.selectedPlant.bind { [ weak self ] indexPath in
            guard let self = self else { return }
            let plant = self.searchResultList.value[indexPath.row]
            
            selectedPlant.accept(plant)
        }.disposed(by: disposeBag)
        
        return Output(transigionNextStep: selectedPlant.asDriver(onErrorDriveWith: .empty()))
    }
}
