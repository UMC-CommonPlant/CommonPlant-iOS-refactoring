//
//  WithdrwalViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/21.
//

import UIKit
import RxSwift
import RxCocoa

class WithdrwalViewModel {
    var isOnCheckBtn = BehaviorRelay<Bool>(value: false)
    
    func dissmissView(_ withdrwalVC: UIViewController) {
        withdrwalVC.dismiss(animated: true)
    }
}
