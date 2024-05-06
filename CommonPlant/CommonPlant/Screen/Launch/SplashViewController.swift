//
//  SplashViewController.swift
//  CommonPlant
//
//  Created by 아라 on 5/6/24.
//

import UIKit
import RxSwift
import Moya

class SplashViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTokenAvailability()
    }
    
    func checkTokenAvailability() {
        let accessToken = try? KeychainManager.read()
        
        TokenAPI.shared.getTokenAvailability(accessToken).subscribe { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(_):
                let mainTabBarVC = MainTabBarController()
                view.window?.rootViewController = mainTabBarVC
                view.window?.makeKeyAndVisible()
            case .failure(let error):
                if let moyaError = error as? MoyaError, let responseBody = try? moyaError.response?.mapJSON() as? [String: Any], let errorCode = responseBody["code"] as? Int {
                    
                    if errorCode == 4007 || errorCode == 2004 {
                        let loginVC = LogInViewController()
                        view.window?.rootViewController = loginVC
                        view.window?.makeKeyAndVisible()
                    }
                }
            }
            
        }.disposed(by: self.disposeBag)
    }
}
