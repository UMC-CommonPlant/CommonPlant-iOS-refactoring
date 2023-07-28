//
//  LogInViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import SnapKit

class LogInViewController: UIViewController {
    // MARK: Properties
    
    // MARK: UI Components
    var textLogoView = UIImageView()
    var imageLogoView = UIImageView()
    var kakaoLoginView = UIView()
    var kakaoImageView = UIImageView()
    var kakaoLoginLabel = UILabel()
    var appleLoginView = UIView()
    var appleImageView = UIImageView()
    var appleLoginLabel = UILabel()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
    }
    
    // MARK: Custom Method
    func setUI() {
        view.backgroundColor = .seaGreen
        
        textLogoView.image = UIImage(named: "TextLogo")
        
        imageLogoView.image = UIImage(named: "SignLogo")
        
        kakaoLoginView.backgroundColor = UIColor(red: 254 / 255.0, green: 229 / 255.0, blue: 0, alpha: 1)
        kakaoLoginView.makeRound(radius: 8)
        
        kakaoLoginLabel.text = "카카오로 로그인"
        kakaoLoginLabel.font = .bodyB3
        kakaoLoginLabel.textAlignment = .center
        kakaoLoginLabel.textColor = .gray6
        
        kakaoImageView.image = UIImage(named: "KakaoLogo")
        
        appleLoginView.backgroundColor = .black
        appleLoginView.makeRound(radius: 8)
        
        appleLoginLabel.text = "Apple로 로그인"
        appleLoginLabel.font = .bodyB3
        appleLoginLabel.textAlignment = .center
        appleLoginLabel.textColor = .white
        
        appleImageView.image = UIImage(named: "AppleLogo")
    }
    
    func setHierarchy() {
        view.addSubview(textLogoView)
        view.addSubview(imageLogoView)
        view.addSubview(kakaoLoginView)
        view.addSubview(appleLoginView)
        
        kakaoLoginView.addSubview(kakaoLoginLabel)
        kakaoLoginView.addSubview(kakaoImageView)
        
        appleLoginView.addSubview(appleLoginLabel)
        appleLoginView.addSubview(appleImageView)
    }
    
    func setLayout() {
        textLogoView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(96)
            make.centerX.equalToSuperview()
        }
        
        imageLogoView.snp.makeConstraints { make in
            make.top.equalTo(textLogoView.snp.bottom).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(186)
        }
        
        kakaoLoginView.snp.makeConstraints { make in
            make.bottom.equalTo(appleLoginView.snp.top).offset(-12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        kakaoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        kakaoLoginLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        appleLoginView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        
        appleImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
        }
        
        appleLoginLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
