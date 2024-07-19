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
    private var historyAPI = HistoryAPI()
    
    init() {
        fetchPopularSearchWords()
    }
    
    struct Input {
        let selectCategory: PublishSubject<CategoryModel>
    }
    
    struct Output {
        let selectedCategory: Driver<CategoryModel>
        let firstDayOfMonth: Driver<String>
        let popularSearchWords: Driver<[HistoryDto]>
        let numberOfItems: Driver<Int>
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
    private let popularSearchWordsRelay = BehaviorRelay<[HistoryDto]>(value: [])
    private let firstDayOfMonthRelay = BehaviorRelay<String>(value: String.thisMonthFirstDayString())
    
    func transform(input: Input) -> Output {
        input.selectCategory
            .bind(to: selectedCategoryRelay)
            .disposed(by: disposeBag)
        
        let numberOfItems = popularSearchWordsRelay
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        return Output(
            selectedCategory: selectedCategoryRelay.asDriver(onErrorDriveWith: .empty()),
            firstDayOfMonth: firstDayOfMonthRelay.asDriver(onErrorDriveWith: .empty()),
            popularSearchWords: popularSearchWordsRelay.asDriver(onErrorDriveWith: .empty()),
            numberOfItems: numberOfItems)
    }
    
    func fetchPopularSearchWords() {
        historyAPI.fetchPopularWordList()
            .subscribe(onSuccess: { [weak self] response in
                self?.popularSearchWordsRelay.accept(response.result.historyDtoList)
                if let formattedDate = response.result.firstDayOfMonth.toFormattedDateString(from: "yyyy-MM-dd", to: "yyyy.M.d") {
                    self?.firstDayOfMonthRelay.accept("\(formattedDate) 기준")
                }
            }, onFailure: { [weak self] error in
                self?.firstDayOfMonthRelay.accept(String.thisMonthFirstDayString())
            })
            .disposed(by: disposeBag)
    }
}
