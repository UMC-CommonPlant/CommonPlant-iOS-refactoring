//
//  SplashViewController.swift
//  CommonPlant
//
//  Created by 아라 on 5/6/24.
//

import UIKit
import SnapKit
import RxSwift
import Moya

final class SplashViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let textLogoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "TextLogo")
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .seaGreen
        
        setLogoView()
        checkTokenAvailability()
    }
    
    func setLogoView() {
        view.addSubview(textLogoView)
        
        textLogoView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    func checkTokenAvailability() {
        do {
            let accessToken = try KeychainManager.read()
            
            TokenAPI.shared.getTokenAvailability().subscribe { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(_):
                    transitionToMain()
                case .failure(let error):
                    if let moyaError = error as? MoyaError, let responseBody = try? moyaError.response?.mapJSON() as? [String: Any], let errorCode = responseBody["code"] as? Int {
                        
                        if errorCode == 4007 || errorCode == 2004 {
                            transitionToLogin()
                        } else {
                            fatalError("Faild To Get Token Availablilty")
                        }
                    }
                }
                
            }.disposed(by: self.disposeBag)
        } catch KeychainError.notFound {
            transitionToLogin()
        } catch {
            fatalError()
        }
    }
    
    func transitionToMain() {
        let mainTabBarVC = MainTabBarController()
        DispatchQueue.main.async {
            self.view.window?.rootViewController = mainTabBarVC
            self.view.window?.makeKeyAndVisible()
        }
    }
    
    func transitionToLogin() {
        let loginVC = LogInViewController()
        DispatchQueue.main.async {
            self.view.window?.rootViewController = loginVC
            self.view.window?.makeKeyAndVisible()
        }
    }
}
