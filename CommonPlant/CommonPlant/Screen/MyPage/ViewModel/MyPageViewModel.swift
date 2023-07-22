//
//  MyPageViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/17.
//

import UIKit
import RxSwift
import RxCocoa

class MyPageViewModel {
    static let shared = MyPageViewModel()
    
    var userSubject: BehaviorSubject<UserInfo>
    var profileImgRelay = BehaviorRelay<UIImage?>(value: nil)
    var disposeBag = DisposeBag()
    
    init() {
        var userInfo = UserInfo(nickName: "커먼플랜트", email: "alwaysweave@gmail.com", profileImgURL: "")
        
        self.userSubject = BehaviorSubject(value: userInfo)
        
        oberveUserInfo()
    }

    private func oberveUserInfo() {
        userSubject.map { userInfo -> UIImage? in
            if userInfo.profileImgURL.isEmpty {
                return UIImage(named: "ProfileGreen")
            } else {
                return nil
            }
        }
        .bind(to: profileImgRelay)
        .disposed(by: disposeBag)
    }
    
    func showEditView(_ myPageVC: UIViewController) {
        let nextVC = EditUserInfoViewController()
        nextVC.modalPresentationStyle = .fullScreen
        myPageVC.present(nextVC, animated: true)
    }
    
    func showSettingView(_ myPageVC: UIViewController) {
        let nextVC = SettingViewController()
        nextVC.modalPresentationStyle = .fullScreen
        myPageVC.present(nextVC, animated: true)
    }
}
