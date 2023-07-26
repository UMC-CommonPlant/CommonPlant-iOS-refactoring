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
    var userSubject: BehaviorSubject<UserInfo>
    var profileImageRelay = BehaviorRelay<UIImage?>(value: nil)
    
    init() {
        var userInfo = UserInfo(nickName: "", email: "", profileImgURL: "")
        
        self.userSubject = BehaviorSubject(value: userInfo)
    }
    
    func showPrivacyPolicyView(_ signUpVC: UIViewController) {
        let nextVC = EditUserInfoViewController()
        nextVC.modalPresentationStyle = .fullScreen
        signUpVC.present(nextVC, animated: true)
    }
}
