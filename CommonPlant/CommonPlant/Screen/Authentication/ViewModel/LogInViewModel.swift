//
//  LogInViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import Foundation
import RxSwift
import RxCocoa
import AuthenticationServices

import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxKakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon

class LogInViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    override init() {
        UserApi.shared.rx.loginWithKakaoAccount()
            .subscribe(onNext:{ (oauthToken) in
                print("loginWithKakaoAccount() success.")
                _ = oauthToken
            }, onError: {error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
    
    public func performAppleSignIn(scope: [ASAuthorization.Scope]? = nil, on window: UIWindow) {
        let result = ASAuthorizationAppleIDProvider().rx.signInWithApple(scope: scope, on: window)
        
        result.subscribe { [weak self] authorization in
            guard let self = self else { return }
            self.getAppleUserInfo(authorization)
        }
    }
    
    func getAppleUserInfo(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let authorizationCode = appleIDCredential.authorizationCode,
              let identifyToken = appleIDCredential.identityToken,
              let authCode = String(data: authorizationCode, encoding: .utf8),
              let appleIdToken = String(data: identifyToken, encoding: .utf8)
        else { return }
        
        let userIdentifier = appleIDCredential.user
        let fullName = appleIDCredential.fullName
        let name =  (fullName?.familyName ?? "") + (fullName?.givenName ?? "")
        let email = appleIDCredential.email
        
        // TODO: 확인을 위한 출력문. 추후 삭제하기
        print("User ID : \(userIdentifier)")
        print("User Email : \(email ?? "")")
        print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
        
        // TODO: 회원가입 여부 확인
    }
}

extension LogInViewModel {
    struct Input {
        let kakaoBtnDidTap: Observable<Void>
    }
    
    struct Output {
        let showSignUpView: Driver<String>
        let showMainView: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showSignUpView = PublishRelay<String>()
        let showMainView = PublishRelay<Void>()
        
        input.kakaoBtnDidTap.bind { [weak self] _ in
            guard let self = self else { return }
            
            if (UserApi.isKakaoTalkLoginAvailable()) {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext:{ (oauthToken) in
                        let accessToken = oauthToken.accessToken
                        
                        LoginAPI.shared.kakao(accessToken).subscribe { result in
                            
                            guard let response = result.element else { return }
                            switch response.status {
                            case 200: showMainView.accept(())
                            case 2001: showSignUpView.accept(accessToken)
                            default: break
                            }
                            
                        }.disposed(by: self.disposeBag)
                    }, onError: {error in
                        print(error)
                    })
                    .disposed(by: disposeBag)
            }
            
        }.disposed(by: disposeBag)
        
        return Output(showSignUpView: showSignUpView.asDriver(onErrorDriveWith: .empty()), showMainView: showMainView.asDriver(onErrorDriveWith: .empty()))
    }
}
