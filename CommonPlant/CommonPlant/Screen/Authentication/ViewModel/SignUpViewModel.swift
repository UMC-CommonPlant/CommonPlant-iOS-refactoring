//
//  SignUpViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import RxSwift
import RxCocoa

class SignUpViewModel {
    static let shared = SignUpViewModel()
    
    var userNickName = BehaviorRelay<String>(value: "")
    var userEmail = BehaviorSubject<String>(value: "")
    var userProfileImgURL = BehaviorSubject<String>(value: "")
    var nickNameState = BehaviorRelay<buttonType>(value: .normal)
    var isAgreePolicy = BehaviorRelay<Bool>(value: false)
    var textCount = BehaviorRelay<Int>(value: 0)
}
