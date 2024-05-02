//
//  SignUpAPI.swift
//  CommonPlant
//
//  Created by 아라 on 4/17/24.
//

import Foundation
import Moya
import RxMoya
import RxSwift

class SignUpAPI {
    static let shared = SignUpAPI()
    let provider: MoyaProvider<SignUpService>
    let disposeBag = DisposeBag()
    
    init( _ provider: MoyaProvider<SignUpService> = MoyaProvider<SignUpService>(plugins: [NetworkLogger()])) {
        self.provider = provider
    }
    
    func getDuplicateNickname(_ nickname: String) -> Single<GetDuplicateNicknameResponse> {
        
        return provider.rx.request(.duplicateNickname(nickname: nickname))
            .map(GetDuplicateNicknameResponse.self)
            
    }
    
    func signUpUser(_ request: PostUserRequest) -> Observable<PostUserResponse> {
        
        return provider.rx.request(.postUser(request: request))
            .asObservable()
            .map { try JSONDecoder().decode(PostUserResponse.self, from: $0.data) }
    }
}
