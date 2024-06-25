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
    
    let initNickname: String
    
    var nicknameState = BehaviorRelay<ButtonState>(value: .disable)
    var imageState = BehaviorRelay<ButtonState>(value: .disable)
    let plantIdx: Int
    
    init(_ plantIdx: Int, plantNickname: String, imgURL: String) {
        self.plantIdx = plantIdx
        initNickname = plantNickname
    }
    
    struct Input {
        let imageDidTap: Observable<Void>
        let changedImage: Observable<Bool?>
        let editingNickname: Observable<String>
    }
    
    struct Output {
        let showImagePicker: Driver<Void>
        let newNickname: Driver<String>
        let buttonState: Driver<ButtonState>
    }
    
    func transform(input: Input) -> Output {
        let buttonState = BehaviorRelay<ButtonState>(value: .disable)
        
        let showImagePicker = PublishRelay<Void>()
        input.imageDidTap.bind(to: showImagePicker).disposed(by: disposeBag)
        
        input.changedImage.bind { [weak self] isChanged in
            guard let self else { return }
            guard let isChanged = isChanged else { return }
            
            imageState.accept(isChanged ? buttonState.value : nicknameState.value)
            buttonState.accept(isChanged ? .enable : buttonState.value)
        }.disposed(by: disposeBag)
        
        let newNickname = PublishRelay<String>()
        input.editingNickname.bind { [weak self] name in
            guard let self = self else { return }
            
            var nickname = name
            
            while nickname.contains("  ") {
                nickname = nickname.replacingOccurrences(of: "  ", with: " ")
            }
            
            if nickname.count > 10 {
                let index = nickname.index(nickname.startIndex, offsetBy: 10)
                nickname = String(nickname[..<index])
            }
            
            let pattern = "^[가-힣a-zA-Z0-9 !_.-^~]*$"
            
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: nickname.utf16.count)
                
                if regex.firstMatch(in: nickname, options: [], range: range) == nil || nickname.count < 2 {
                    nicknameState.accept(.disable)
                    buttonState.accept(.disable)
                } else {
                    nicknameState.accept(initNickname == nickname ? imageState.value : .enable)
                    buttonState.accept(initNickname == nickname ? imageState.value : .enable)
                }
            }
            
            newNickname.accept(name)
        }.disposed(by: disposeBag)
        
        return Output(showImagePicker: showImagePicker.asDriver(onErrorJustReturn: ()), newNickname: newNickname.asDriver(onErrorJustReturn: ""), buttonState: buttonState.asDriver())
    }
}

extension EditPlantViewModel {
    enum ButtonState {
        case enable
        case disable
        case onClick
    }
}
