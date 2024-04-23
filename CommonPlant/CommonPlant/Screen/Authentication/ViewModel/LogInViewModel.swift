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
import KakaoSDKAuth
import KakaoSDKUser

class LogInViewModel: NSObject {
    let disposeBag = DisposeBag()
    
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
    
    
    func callLoginAPI(_ token: String, showMainView: PublishRelay<Void>, showSignUpView: PublishRelay<(String, String)>) {
        LoginAPI.shared.kakao(token).subscribe { [weak self] result in
            guard let self = self else { return }
            
            guard let response = result.element else { return }
            switch response.status {
            case 200: showMainView.accept(())
            case 2001:
                guard let email = result.element?.result else { return }
                showSignUpView.accept((email, "kakao"))
            default: break
            }
            
        }.disposed(by: self.disposeBag)
    }
}

extension LogInViewModel {
    struct Input {
        let kakaoBtnDidTap: Observable<Void>
    }
    
    struct Output {
        let showSignUpView: Driver<(String, String)>
        let showMainView: Driver<Void>
    }
    
    func transform(input: Input) -> Output {
        let showSignUpView = PublishRelay<(String, String)>()
        let showMainView = PublishRelay<Void>()
        
        input.kakaoBtnDidTap.subscribe { [weak self] _ in
            guard let self = self else { return }
            
            if UserApi.isKakaoTalkLoginAvailable() {
                UserApi.shared.rx.loginWithKakaoTalk()
                    .subscribe(onNext: { [weak self] oauthToken in
                        guard let self = self else { return }
                        
                        let accessToken = oauthToken.accessToken
                        
                        callLoginAPI(accessToken, showMainView: showMainView, showSignUpView: showSignUpView)
                    }, onError: { error in
                        // TODO: 에러 처리
                    }).disposed(by: self.disposeBag)
            } else {
                UserApi.shared.rx.loginWithKakaoAccount()
                    .subscribe(onNext: { [weak self] oauthToken in
                        guard let self = self else { return }
                        
                        let accessToken = oauthToken.accessToken
                        
                        callLoginAPI(accessToken, showMainView: showMainView, showSignUpView: showSignUpView)
                    }, onError: { error in
                        // TODO: 에러 처리
                    }).disposed(by: self.disposeBag)
            }
            
        }.disposed(by: disposeBag)
        
        return Output(showSignUpView: showSignUpView.asDriver(onErrorDriveWith: .empty()), showMainView: showMainView.asDriver(onErrorDriveWith: .empty()))
    }
}
