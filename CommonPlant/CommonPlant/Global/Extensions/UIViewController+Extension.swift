////
////  UIViewController+Extension.swift
////  CommonPlant
////
////  Created by 아라 on 2023/08/16.
////
//
import UIKit

enum ImageSettingState {
    case newImage
    case defaultImage
    case cancle
}

extension UIViewController {
    func showImageSettingAlert(completion: @escaping (ImageSettingState) -> Void) {
        let actionSheet = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: {(ACTION:UIAlertAction) in
            completion(.newImage)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(ACTION:UIAlertAction) in
            completion(.defaultImage)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: {(ACTION:UIAlertAction) in
            completion(.cancle)
        }))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func moveToSetting() {
        let alertController = UIAlertController(title: "사진 접근 권한이 없습니다.", message: "설정으로 이동하여 권한 설정을 해주세요.", preferredStyle: UIAlertController.Style.alert)

        let okAction = UIAlertAction(title: "확인", style: .default) { (action) in

            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }

            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(okAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: false, completion: nil)
    }
}
