//
//  LogInViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import AuthenticationServices

class LogInViewModel: NSObject {
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
