//
//  EditUserInfoViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/21.
//

import UIKit
import RxSwift
import RxCocoa

enum buttonType: String {
    case normal = ""
    case unusable = "2~10자의 닉네임으로 입력해주세요 or 중복된 닉네임입니다"
    case usable = "사용 가능한 닉네임입니다"
}

class EditUserInfoViewModel {
    var nickNameState = BehaviorRelay<buttonType>(value: .normal)
    var profileImgState = BehaviorRelay<buttonType>(value: .normal)
    var profileImgURL = BehaviorSubject<String>(value: "")
    var textCount = BehaviorRelay<Int>(value: 0)
    
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
