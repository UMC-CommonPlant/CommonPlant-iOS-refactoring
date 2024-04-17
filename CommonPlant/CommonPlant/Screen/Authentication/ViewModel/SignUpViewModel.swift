//
//  SignUpViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel {
    enum SubmitState {
        case enable
        case disable
        case onClick
    }
    
    let disposeBag = DisposeBag()
    
    let privacyVM = PrivacyViewModel()
    var isAgreePolicy = PublishRelay<Bool>()
    
    init() {
        privacyVM.isAgreePolicy.subscribe { [weak self] isAgree in
            guard let self = self else { return }
            isAgreePolicy.accept(isAgree)
        }.disposed(by: disposeBag)
    }
}

extension SignUpViewModel {
    struct Input {
        let backBtnDidTap: Observable<Void>
        let profileImgDidTap: Observable<Void>
        let selectedNewImage: Observable<Void>
        let selectedDefaultImage: Observable<Void>
        let editingNickname: Observable<String>
        let endEditingNickname: Observable<Void>
        let duplicateBtnDidTap: Observable<Void>
        let privacyDidTap: Observable<Void>
        let submitBtnDidTap: Observable<Void>
    }
    
    struct Output {
        let dismissView: Driver<Void>
        let showImgSettingAlert: Driver<Void>
        let showImagePicker: Driver<Void>
        let changeDefaultImage: Driver<Void>
        let nicknameText: Driver<String>
        let showDuplicateBtn: Driver<Void>
        let nicknameState: Driver<ButtonType>
        let showPrivacyView: Driver<AnyObject>
        let submitBtnState: Driver<SubmitState>
    }
    
    func transform(input: Input) -> Output {
        let submitBtnState = BehaviorRelay(value: SubmitState.disable)
        
        let dismissView = PublishRelay<Void>()
        input.backBtnDidTap.bind(to: dismissView).disposed(by: disposeBag)
        let showImgSettingAlert = PublishRelay<Void>()
        input.profileImgDidTap.bind(to: showImgSettingAlert).disposed(by: disposeBag)
        let showImagePicker = PublishRelay<Void>()
        input.selectedNewImage.bind(to: showImagePicker).disposed(by: disposeBag)
        let changeDefaultImage = PublishRelay<Void>()
        input.selectedDefaultImage.bind(to: changeDefaultImage).disposed(by: disposeBag)
        let nicknameText = PublishRelay<String>()
        input.editingNickname.bind { [weak self] name in
            guard let self = self else { return }
            var name = name
            
            let pattern = "^[가-힣a-zA-Z0-9]*$"
            
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: name.utf16.count)
                if regex.firstMatch(in: name, options: [], range: range) != nil {
                    name = regex.stringByReplacingMatches(in: name, options: [], range: range, withTemplate: "")
                }
            }
            
            nicknameText.accept(name)
        }.disposed(by: disposeBag)
        
        let showDuplicateBtn = PublishRelay<Void>()
        input.endEditingNickname.bind(to: showDuplicateBtn).disposed(by: disposeBag)
        
        let nicknameState = BehaviorRelay(value: ButtonType.normal)
        input.duplicateBtnDidTap.bind { [weak self] _ in
            guard let self = self else { return }
            
            // TODO: 중복 체크 서버 연동
            // TODO: 결과에 따라 nicknameState accept하기
            // TODO: submitBtnState 값도 변경
        }.disposed(by: disposeBag)
        
        let showPrivacyView = PublishRelay<AnyObject>()
        input.privacyDidTap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            showPrivacyView.accept(privacyVM)
        }.disposed(by: disposeBag)
        
        return Output(dismissView: dismissView.asDriver(onErrorDriveWith: .empty()), showImgSettingAlert: showImgSettingAlert.asDriver(onErrorDriveWith: .empty()), showImagePicker: showImagePicker.asDriver(onErrorDriveWith: .empty()), changeDefaultImage: changeDefaultImage.asDriver(onErrorDriveWith: .empty()), nicknameText: nicknameText.asDriver(onErrorJustReturn: ""), showDuplicateBtn: showDuplicateBtn.asDriver(onErrorDriveWith: .empty()), nicknameState: nicknameState.asDriver(), showPrivacyView: showPrivacyView.asDriver(onErrorDriveWith: .empty()), submitBtnState: submitBtnState.asDriver())
    }
}
