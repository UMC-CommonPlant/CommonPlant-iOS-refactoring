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
    // 싱글톤 패턴으로 다른 ViewController에서도 접근 가능
    static let shared = MyPageViewModel()
    
    var userSubject: BehaviorSubject<UserInfo>
    var infoProfileRelay = BehaviorRelay<UIImage?>(value: nil)
    var editProfileRelay = BehaviorRelay<UIImage?>(value: nil)
    var disposeBag = DisposeBag()
    
    init() {
        var userInfo = UserInfo(nickName: "커먼플랜트", email: "alwaysweave@gmail.com", profileImgURL: "")
        
        self.userSubject = BehaviorSubject(value: userInfo)
        
        oberveUserInfo()
    }

    private func oberveUserInfo() {
        userSubject.map { userInfo -> (UIImage?, UIImage?) in
            if userInfo.profileImgURL.isEmpty {
                return (UIImage(named: "ProfileGreen"), UIImage(named: "ProfileGray"))
            } else {
                // 이미지 다운 로직
                return (nil, nil)
            }
        }
        .subscribe(onNext: { [weak self] info, edit in
            self?.infoProfileRelay.accept(info)
            if info != edit {
                self?.editProfileRelay.accept(edit)
            }
        })
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
