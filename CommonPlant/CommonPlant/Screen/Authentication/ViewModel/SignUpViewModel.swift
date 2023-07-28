//
//  SignUpViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewModel {
    static let shared = SignUpViewModel()
    
    var userSubject: BehaviorSubject<UserInfo>
    var profileImageRelay = BehaviorRelay<UIImage?>(value: nil)
    var nickNameState = BehaviorRelay<buttonType>(value: .normal)
    var isAgreePolicy = BehaviorSubject<Bool>(value: false)
    var textCount = BehaviorSubject<Int>(value: 0)
    
    init() {
        var userInfo = UserInfo(nickName: "", email: "", profileImgURL: "")
        
        self.userSubject = BehaviorSubject(value: userInfo)
    }
    
    func checkNickNameCount(_ nickName: String) -> Int {
        return nickName.count
    }
    
    func checkNickNameVaild(_ textField: UITextField) -> buttonType {
        guard let text = textField.text else { return .normal }
        if text.count > 1 && text.count < 10 {
            return .usable
        } else {
            return .unusable
        }
    }
    
    func dissmissView(_ editVC: UIViewController) {
        editVC.dismiss(animated: true)
    }
}
