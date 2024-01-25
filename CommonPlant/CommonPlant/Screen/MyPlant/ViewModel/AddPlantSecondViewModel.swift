//
//  AddPlantSecondViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 1/23/24.
//

import Foundation
import RxSwift
import RxCocoa

class AddPlantSecondViewModel {
    let disposeBag = DisposeBag()
    
    struct Input {
        let imageDidTap: Observable<Void>
        let selectedNewImage: Observable<Void>
        let selectedDefaultImage: Observable<Void>
        let selectedCancle: Observable<Void>
        let editingNickname: Observable<String>
        let placeDidTap: Observable<Void>
        let selectedPlace: Observable<IndexPath>
        let deletePlaceBtnDidTap: Observable<Void>
        let dateDidTap: Observable<Void>
        let selectedDate: Observable<Date>
        let cancleBtnDidTap: Observable<Void>
        let submitBtnDidTap: Observable<Void>
    }
    
    struct Output {
        let showImgSettingAlert: Driver<Void>
        let showImagePicker: Driver<Void>
        let changeDefaultImage: Driver<Void>
        let cancleSelectImage: Driver<Void>
        let nicknameState: Driver<String>
        let showPlaceList: Driver<Void>
        let selectPlace: Driver<String>
        let resetPlace: Driver<Void>
        let showDatePicker: Driver<Void>
        let selectedWateredDate: Driver<String>
        let cancleAddPlant: Driver<Void>
        let submitPlant: Driver<Void>
        let submitBtnState: Driver<SubmitState>
    }
    
    func transform(input: Input) -> Output {
        let submitBtnState = BehaviorRelay(value: SubmitState.disable)
        let showImgSettingAlert = input.imageDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let showImagePicker = input.selectedNewImage
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let changeDefaultImage = input.selectedDefaultImage
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let cancleSelectImage = input.selectedCancle
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let nicknameState = input.editingNickname
            .map { name in
                var name = name
                
                if name.contains("\n") {
                    name.removeLast()
                }
                
                if name.count > 10 {
                    let index = name.index(name.startIndex, offsetBy: 10)
                    name = String(name[..<index])
                }
                
                if name.count > 0 {
                    submitBtnState.accept(.enable)
                }
                
                return name
            }
            .asDriver(onErrorJustReturn: "")
        let showPlaceList = input.placeDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let selectPlace = input.selectedPlace
            .map { index in
                // TODO: 해당 인덱스 장소 리턴하기
                return ""
            }
            .asDriver(onErrorJustReturn: "")
        let resetPlace = input.deletePlaceBtnDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let showDatePicker = input.dateDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let selectedWateredDate = input.selectedDate
            .map { [ weak self] date in
                guard let self = self else { return "ERROR" }
                return self.dateToString(date)
            }
            .asDriver(onErrorJustReturn: "")
        let cancleAddPlant = input.cancleBtnDidTap
            .map { _ in () }
            .asDriver(onErrorDriveWith: .empty())
        let submitPlant = input.submitBtnDidTap
            .map { _ in ()
                // TODO: 네트워킹
                submitBtnState.accept(.onClick)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        return Output(showImgSettingAlert: showImgSettingAlert,
               showImagePicker: showImagePicker,
               changeDefaultImage: changeDefaultImage,
               cancleSelectImage: cancleSelectImage,
               nicknameState: nicknameState,
               showPlaceList: showPlaceList,
               selectPlace: selectPlace,
               resetPlace: resetPlace,
               showDatePicker: showDatePicker,
               selectedWateredDate: selectedWateredDate,
               cancleAddPlant: cancleAddPlant,
               submitPlant: submitPlant,
               submitBtnState: submitBtnState.asDriver(onErrorJustReturn: .disable))
    }
    
    func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        return dateFormatter.string(from: date)
    }
}

extension AddPlantSecondViewModel {
    enum SubmitState {
        case enable
        case disable
        case onClick
    }
}
