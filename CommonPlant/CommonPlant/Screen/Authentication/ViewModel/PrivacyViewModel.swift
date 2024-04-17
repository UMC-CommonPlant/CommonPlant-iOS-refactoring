//
//  PrivacyViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/27.
//

import UIKit
import RxSwift
import RxCocoa

class PrivacyViewModel {
    let disposeBag = DisposeBag()
    var isAgreePolicy = BehaviorSubject<Bool>(value: false)
    
    func dissmissView(_ privacyVC: UIViewController) {
        privacyVC.dismiss(animated: true)
    }
}
