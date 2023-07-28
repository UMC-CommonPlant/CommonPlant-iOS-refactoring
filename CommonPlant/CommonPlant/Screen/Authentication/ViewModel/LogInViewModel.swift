//
//  LogInViewModel.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit

class LogInViewModel {
    var isExistUser = false
    
    func kakaoLogIn() {
        isExistUser = false
        
        if isExistUser {
            showMainView()
        } else {
            showSignUpView()
        }
    }
    
    func appleLogIn() {
        isExistUser = true
        
        if isExistUser {
            showMainView()
        } else {
            showSignUpView()
        }
    }
    
    func showSignUpView() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        
        let signUpVC = SignUpViewController()
        
        window?.rootViewController?.present(signUpVC, animated: true)
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
}
