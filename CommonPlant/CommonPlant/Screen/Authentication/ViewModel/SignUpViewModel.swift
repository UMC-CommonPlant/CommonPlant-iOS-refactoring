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
    
    enum NicknameState {
        case available
        case duplicate
        case unavailable
    }
    
    let disposeBag = DisposeBag()
    let privacyVM = PrivacyViewModel()
    let nicknameState = PublishRelay<NicknameState>()
    let isAgreePolicy = PublishRelay<Bool>()
    let submitBtnState = PublishRelay<SubmitState>()
    
    var email: String
    var provider: String
    var nickname: String = ""
    
    init(_ email: String, _ provider: String) {
        self.email = email
        self.provider = provider
        
        privacyVM.isAgreePolicy
            .subscribe { [weak self] isAgree in
                guard let self = self else { return }
                isAgreePolicy.accept(isAgree)
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(nicknameState, isAgreePolicy).map { (nicknameState , isAgree) in
            return (nicknameState == .available && isAgree) ? .enable : .disable
        }
        .bind(to: submitBtnState)
        .disposed(by: disposeBag)
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
        let duplicateBtnDidTap: Observable<String>
        let privacyDidTap: Observable<Void>
        let submitBtnDidTap: Observable<Data?>
    }
    
    struct Output {
        let dismissView: Driver<Void>
        let showImgSettingAlert: Driver<Void>
        let showImagePicker: Driver<Void>
        let changeDefaultImage: Driver<Void>
        let nicknameText: Driver<String>
        let showDuplicateBtn: Driver<Void>
        let showPrivacyView: Driver<AnyObject>
    }
    
    func transform(input: Input) -> Output {
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
            
            if name.count > 10 {
                name.removeLast()
            }
            
            if (name.contains(" ")) || (name.contains("\n")) {
                name.removeAll { ($0 == " ") || ($0 == "\n") }
            }
            
            nicknameText.accept(name)
        }.disposed(by: disposeBag)
        
        let showDuplicateBtn = PublishRelay<Void>()
        input.endEditingNickname.bind(to: showDuplicateBtn).disposed(by: disposeBag)
        
        input.duplicateBtnDidTap.subscribe(onNext: { [weak self] nickname in
            
            guard let self = self else { return }
            
            let pattern = "^[가-힣a-zA-Z0-9]*$"
            
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) {
                let range = NSRange(location: 0, length: nickname.utf16.count)
                
                if regex.firstMatch(in: nickname, options: [], range: range) == nil || nickname.count < 2 {
                    nicknameState.accept(.unavailable)
                } else {
                    SignUpAPI.shared.getDuplicateNickname(nickname).subscribe { [weak self] result in
                        guard let self = self, let response = result.element else { return }
                        
                        switch response.status {
                        case 200: 
                            nicknameState.accept(.available)
                            self.nickname = nickname
                        case 4004:
                            nicknameState.accept(.duplicate)
                        case 4005:
                            nicknameState.accept(.unavailable)
                        default:
                            break
                        }
                    }.disposed(by: self.disposeBag)
                }
            }
        }).disposed(by: disposeBag)
        
        let showPrivacyView = PublishRelay<AnyObject>()
        input.privacyDidTap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            showPrivacyView.accept(privacyVM)
        }.disposed(by: disposeBag)
        
        input.submitBtnDidTap.subscribe { [weak self] data in
            guard let self = self else { return }
            
            let request = PostUserRequest(email: email, name: nickname, provider: provider, imgData: data)
            
            SignUpAPI.shared.signUpUser(request).subscribe { [weak self] result in
                
                guard let self = self, let response = result.element else { return }
                
            }.disposed(by: disposeBag)
            
            dismissView.accept(())
        }.disposed(by: disposeBag)
        
        return Output(dismissView: dismissView.asDriver(onErrorDriveWith: .empty()), showImgSettingAlert: showImgSettingAlert.asDriver(onErrorDriveWith: .empty()), showImagePicker: showImagePicker.asDriver(onErrorDriveWith: .empty()), changeDefaultImage: changeDefaultImage.asDriver(onErrorDriveWith: .empty()), nicknameText: nicknameText.asDriver(onErrorJustReturn: ""), showDuplicateBtn: showDuplicateBtn.asDriver(onErrorDriveWith: .empty()), showPrivacyView: showPrivacyView.asDriver(onErrorDriveWith: .empty()))
    }
}
