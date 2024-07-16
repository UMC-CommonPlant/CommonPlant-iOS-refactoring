//
//  PlantSearchViewModel.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/31.
//

import Foundation
import RxSwift
import RxCocoa

class PlantInfoViewModel: ViewModelType {
    private let disposeBag = DisposeBag()
    
    struct Input {
        let selectCategory: PublishSubject<CategoryModel>
    }
    
    struct Output {
        let selectedCategory: Driver<CategoryModel>
    }
    
    let categories: [CategoryModel] = [
        CategoryModel(label: "원룸", color: "OneRoomColor", icon: "OneRoom"),
        CategoryModel(label: "공기정화", color: "AirPurificationColor", icon: "AirPurification"),
        CategoryModel(label: "초보집사", color: "BeginnerColor", icon: "Beginner"),
        CategoryModel(label: "채광", color: "SunlightColor", icon: "Sunlight"),
        CategoryModel(label: "물 주기", color: "WaterPreferenceColor", icon: "WateringPot"),
        CategoryModel(label: "인테리어", color: "InteriorColor", icon: "Interior")
    ]
    
    private let selectedCategoryRelay = PublishRelay<CategoryModel>()
    
    func transform(input: Input) -> Output {
        input.selectCategory
            .bind(to: selectedCategoryRelay)
            .disposed(by: disposeBag)
        
        return Output(selectedCategory: selectedCategoryRelay.asDriver(onErrorDriveWith: .empty()))
    }
}
