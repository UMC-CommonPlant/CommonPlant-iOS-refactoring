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
    
    let plantIdx: Int
    let initNickname: String
    let initCycle: Int
    
    var nicknameState = BehaviorRelay<ButtonState>(value: .none)
    var imageState = BehaviorRelay<ButtonState>(value: .none)
    var cycleState = BehaviorRelay<ButtonState>(value: .none)
    
    init(_ plantIdx: Int, plantNickname: String, waterCycle: Int, imgURL: String) {
        self.plantIdx = plantIdx
        initNickname = plantNickname
        initCycle = waterCycle
    }
    
    struct Input {
        let imageDidTap: Observable<Void>
        let changedImage: Observable<Bool?>
        let editingNickname: Observable<String>
        let editingCycle: Observable<String>
        let completeBtnDidTap: Observable<PutPlantRequest>
    }
    
    struct Output {
        let showImagePicker: Driver<Void>
        let newNickname: Driver<String>
        let newCycle: Driver<String>
        let buttonState: Driver<ButtonState>
        let popToPreviousView: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let buttonState = BehaviorRelay<ButtonState>(value: .disable)
        
        Observable.combineLatest(nicknameState, imageState, cycleState)
            .map { nickname, image, cycle in
                if nickname == .disable || image == .disable || cycle == .disable {
                    return .disable
                }
                
                return (nickname == .enable || image == .enable || cycle == .enable) ? .enable : .disable
            }.bind(to: buttonState)
            .disposed(by: disposeBag)
        
        let showImagePicker = PublishRelay<Void>()
        input.imageDidTap.bind(to: showImagePicker).disposed(by: disposeBag)
        
        input.changedImage.bind { [weak self] isChanged in
            guard let self else { return }
            guard let isChanged = isChanged else { return }
            
            imageState.accept(isChanged ? .enable : .none)
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
                } else {
                    nicknameState.accept(initNickname == nickname ? .none : .enable)
                }
            }
            
            newNickname.accept(name)
        }.disposed(by: disposeBag)
        
        let newCycle = PublishRelay<String>()
        input.editingCycle.bind { [weak self] cycle in
            guard let self = self else { return }
            let cycle = cycle.filter { $0.isNumber }
            
            newCycle.accept(cycle)
            guard let intCycle = Int(cycle) else {
                cycleState.accept(.disable)
                return
            }
            cycleState.accept(initCycle == intCycle ? .none : intCycle < 1 ? .disable : .enable)
        }.disposed(by: disposeBag)
        
        let popToPreviousView = PublishRelay<Void>()
        input.completeBtnDidTap.bind { [weak self] request in
            guard let self else { return }
            
            PlantAPI.shared.putPlant(request)
                .subscribe { result in
                    switch result {
                    case .success(_):
                        popToPreviousView.accept(())
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }.disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        return Output(showImagePicker: showImagePicker.asDriver(onErrorJustReturn: ()), newNickname: newNickname.asDriver(onErrorJustReturn: ""), newCycle: newCycle.asDriver(onErrorJustReturn: ""), buttonState: buttonState.asDriver(), popToPreviousView: popToPreviousView.asDriver(onErrorDriveWith: .empty()))
    }
}

extension EditPlantViewModel {
    enum ButtonState {
        case none
        case enable
        case disable
        case onClick
    }
}
