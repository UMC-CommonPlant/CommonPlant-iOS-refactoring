//
//  File.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/18.
//

import UIKit
import RxSwift

class SettingViewModel {
    var isActiveNotification: Observable<Bool> = Observable.just(true)
    
    func showWithdrwalView(_ settingVC: UIViewController) {
        let nextVC = WithdrwalViewController()
        nextVC.modalPresentationStyle = .fullScreen
        settingVC.present(nextVC, animated: true)
    }
    
    func showEditInfoView(_ settingVC: UIViewController) {
        let nextVC = EditUserInfoViewController()
        nextVC.modalPresentationStyle = .fullScreen
        settingVC.present(nextVC, animated: true)
    }
    
    func dissmissView(_ settingVC: UIViewController) {
        settingVC.dismiss(animated: true)
    }
}
