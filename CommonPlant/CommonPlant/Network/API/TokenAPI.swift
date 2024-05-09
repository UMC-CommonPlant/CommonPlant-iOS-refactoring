//
//  TokenAPI.swift
//  CommonPlant
//
//  Created by 아라 on 5/5/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class TokenAPI {
    static let shared = TokenAPI()
    let provider: MoyaProvider<TokenService>
    let disposeBag = DisposeBag()
    
    init( _ provider: MoyaProvider<TokenService> = MoyaProvider<TokenService>(plugins: [NetworkLogger()])) {
        self.provider = provider
    }
    
    func getTokenAvailability() -> Single<TokenResponse> {
        
        return provider.rx.request(.getTokenAvailability)
            .map(TokenResponse.self)
    }
}
