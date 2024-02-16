//
//  EditPlantViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2/11/24.
//

import Foundation
import RxSwift
import RxCocoa

class EditPlantViewModel {
    let disposeBag = DisposeBag()
    
    let initPlant: Plant
    //let currentPlant = PublishRelay<Plant>()
    var imageState: ButtonState = .disable
    
    init() {
        //currentPlant.accept(Plant(plantImage: "https://commonplantbucket.s3.ap-northeast-2.amazonaws.com/72e88997-7dcc-4a72-8a38-348d7754076b..jpeg", plantName: "몬테"))
        initPlant = Plant(plantImage: "", plantName: "몬테")
    }
    
    struct Input {
        let imageDidTap: Observable<Void>
        let selectedNewImage: Observable<Void>
        let selectedDefaultImage: Observable<Void>
        let changedImage: Observable<Bool?>
        let editingNickname: Observable<String>
    }
    
    struct Output {
        let showImgSettingAlert: Driver<Void>
        let showImagePicker: Driver<Void>
        let changeDefaultImage: Driver<Void>
        let newNickname: Driver<String>
        let buttonState: Driver<ButtonState>
    }
    
    func transform(input: Input) -> Output {
        let buttonState = BehaviorRelay<ButtonState>(value: .disable)
        
        let showImgSettingAlert = PublishRelay<Void>()
        input.imageDidTap.bind(to: showImgSettingAlert).disposed(by: disposeBag)
        
        let showImagePicker = PublishRelay<Void>()
        input.selectedNewImage.bind(to: showImagePicker).disposed(by: disposeBag)
        
        let changeDefaultImage = PublishRelay<Void>()
        input.selectedDefaultImage.bind(to: changeDefaultImage).disposed(by: disposeBag)
        
        input.changedImage.bind { [weak self] isChanged in
            guard self != nil else { return }
            guard let isChanged = isChanged else { return }
            
            buttonState.accept(isChanged ? .enable : buttonState.value)
        }.disposed(by: disposeBag)
        
        let newNickname = PublishRelay<String>()
        input.editingNickname.bind { [weak self] name in
            guard let self = self else { return }
            var name = name
            
            if name.contains("\n") {
                name.removeLast()
            }
            
            if name.count > 10 {
                let index = name.index(name.startIndex, offsetBy: 10)
                name = String(name[..<index])
            }
            
            if name != initPlant.plantName && name.count > 0 {
                buttonState.accept(.enable)
            } else {
                buttonState.accept(.disable)
            }
            
            newNickname.accept(name)
        }.disposed(by: disposeBag)
        
        return Output(showImgSettingAlert: showImgSettingAlert.asDriver(onErrorJustReturn: ()), showImagePicker: showImagePicker.asDriver(onErrorJustReturn: ()), changeDefaultImage: changeDefaultImage.asDriver(onErrorJustReturn: ()), newNickname: newNickname.asDriver(onErrorJustReturn: ""), buttonState: buttonState.asDriver())
    }
}

extension EditPlantViewModel {
    enum ButtonState {
        case enable
        case disable
        case onClick
    }
}
