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

class LoginAPI {
    static let shared = LoginAPI()
    let provider: MoyaProvider<LoginService>
    let disposeBag = DisposeBag()
    
    init( _ provider: MoyaProvider<LoginService> = MoyaProvider<LoginService>(plugins: [NetworkLogger()])) {
        self.provider = provider
    }
    
    func kakao(_ token: String) -> Observable<KakaoResponse> {
        
        return provider.rx.request(.kakaoLogin(token: token))
            .asObservable()
            .map { try JSONDecoder().decode(KakaoResponse.self, from: $0.data) }
            
    }
}
