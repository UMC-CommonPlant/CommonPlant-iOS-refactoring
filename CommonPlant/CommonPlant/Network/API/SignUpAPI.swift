//
//  SignUpAPI.swift
//  CommonPlant
//
//  Created by 아라 on 4/17/24.
//

import UIKit
import Moya
import RxMoya
import RxSwift

class SignUpAPI {
    static let shared = SignUpAPI()
    let provider = MoyaProvider<SignUpService>()
    let disposeBag = DisposeBag()
    
    func getDuplicateNickname(_ nickname: String) -> Observable<GetDuplicateNicknameResponse> {
        
        return provider.rx.request(.duplicateNickname(nickname: nickname))
            .asObservable()
            .map { try JSONDecoder().decode(GetDuplicateNicknameResponse.self, from: $0.data) }
            
    }
    
    func signUpUser(_ request: PostUserRequest, _ profileImage: UIImage?) -> Observable<PostUserResponse> {
        
        return provider.rx.request(.postUser(request: request, image: profileImage))
            .asObservable()
            .map { try JSONDecoder().decode(PostUserResponse.self, from: $0.data) }
    }
}
