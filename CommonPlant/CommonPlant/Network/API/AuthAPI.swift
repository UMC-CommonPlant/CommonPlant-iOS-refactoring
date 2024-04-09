//
//  AuthAPI.swift
//  CommonPlant
//
//  Created by 아라 on 4/8/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class AuthAPI {
    static let shared = AuthAPI()
    let provider = MoyaProvider<LoginService>()
    let disposeBag = DisposeBag()
    
    func kakao(_ token: String) -> Observable<KakaoResponse> {
        
        return provider.rx.request(.kakaoLogin(token: token))
            .asObservable()
            .map { try JSONDecoder().decode(KakaoResponse.self, from: $0.data) }
            
    }
}
