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
}

extension AddPlantSecondViewModel {
    enum SubmitState {
        case enable
        case disable
        case onClick
    }
}
