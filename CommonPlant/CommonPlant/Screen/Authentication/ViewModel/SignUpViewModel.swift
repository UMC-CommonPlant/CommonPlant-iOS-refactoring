//
//  SignUpViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class SignUpViewModel: PHPickerViewControllerDelegate {
    static let shared = SignUpViewModel()
    
    var userSubject: BehaviorSubject<UserInfo>
    var profileImageRelay = BehaviorRelay<UIImage?>(value: UIImage(named: "ProfileGreen"))
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
    
    func showPrivacyPolicyView(_ signUpVC: UIViewController) {
        let nextVC = PrivacyViewController()
        signUpVC.present(nextVC, animated: true)
    }
    
    func showMainView() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let mainVC = MainTabBarController()
        
        
        UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window?.rootViewController = mainVC
        }, completion: nil)
    }
    
    func dissmissView(_ signUpVC: UIViewController) {
        signUpVC.dismiss(animated: true)
    }
    
    func showSettingProfileAlert(_ signUpVC: UIViewController) {
        let actionSheet = UIAlertController(title: "프로필 사진 설정", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "앨범에서 사진 선택", style: .default, handler: {(ACTION:UIAlertAction) in
            self.checkPermissionState(signUpVC)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "기본 이미지로 변경", style: .default, handler: {(ACTION:UIAlertAction) in
            self.profileImageRelay.accept(UIImage(named: "ProfileGreen"))
        }))
        
        actionSheet.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        signUpVC.present(actionSheet, animated: true, completion: nil)
    }
    
    func checkPermissionState(_ signUpVC: UIViewController) {
        let requiredAccessLevel: PHAccessLevel = .readWrite
        PHPhotoLibrary.requestAuthorization(for: requiredAccessLevel) { authorizationStatus in
            DispatchQueue.main.async {
                switch authorizationStatus {
                case .authorized, .limited:
                    self.showPhotoPicker(signUpVC)
                case .denied:
                    self.moveToSetting(signUpVC)
                default:
                    print("Unimplemented")
                }
            }
        }
    }
    
    func showPhotoPicker(_ signUpVC: UIViewController) {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        
        picker.delegate = self
        
        signUpVC.present(picker, animated: true, completion: nil)
    }
    
    func moveToSetting(_ signUpVC: UIViewController) {
        let alertController = UIAlertController(title: "권한 거부됨", message: "앨범 접근이 거부 되었습니다. 앱의 일부 기능을 사용할 수 없어요", preferredStyle: UIAlertController.Style.alert)
        
        let okAction = UIAlertAction(title: "권한 설정으로 이동하기", style: .default) { (action) in
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }
        let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        signUpVC.present(alertController, animated: false, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        print(results.count)
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    guard let image = image as? UIImage else { return }
                    self.profileImageRelay.accept(image)
                }
            }
        }
    }
}
