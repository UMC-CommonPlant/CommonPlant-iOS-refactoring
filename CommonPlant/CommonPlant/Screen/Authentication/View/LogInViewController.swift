//
//  LogInViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import SnapKit
import RxSwift
import AuthenticationServices

class LogInViewController: UIViewController {
    // MARK: Properties
    var viewModel = LogInViewModel()
    lazy var input = LogInViewModel.Input(kakaoBtnDidTap: kakaoLoginView.rx.tapGesture().map { _ in }.asObservable())
    lazy var output = viewModel.transform(input: input)
    
    // MARK: UI Components
    var textLogoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "TextLogo")
        return view
    }()
    var imageLogoView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "SignLogo")
        return view
    }()
    var kakaoLoginView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 254 / 255.0, green: 229 / 255.0, blue: 0, alpha: 1)
        view.makeRound(radius: 8)
        return view
    }()
    var kakaoImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "KakaoLogo")
        return view
    }()
    var kakaoLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "카카오로 로그인"
        label.font = .bodyB3
        label.textAlignment = .center
        label.textColor = .gray6
        return label
    }()
    var appleLoginView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.makeRound(radius: 8)
        return view
    }()
    var appleImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "AppleLogo")
        return view
    }()
    var appleLoginLabel: UILabel = {
        let label = UILabel()
        label.text = "Apple로 로그인"
        label.font = .bodyB3
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .seaGreen
        
        bind()
        setConstraints()
    }
    
    // MARK: Custom Method
    func bind() {
        output.showMainView.drive { [weak self] _ in
            guard let self = self else { return }
            
        }.disposed(by: viewModel.disposeBag)
        
        output.showSignUpView.drive { [weak self] email in
            guard let self = self else { return }
            
            let nextVC = SignUpViewController()
            
            self.present(nextVC, animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        appleLoginView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                viewModel.performAppleSignIn(scope: [.fullName, .email], on: self.view.window!)
            })
            .disposed(by: viewModel.disposeBag)
    }
    
    func setConstraints() {
        [textLogoView, imageLogoView, kakaoLoginView, appleLoginView].forEach {
            view.addSubview($0)
        }
        
        [kakaoLoginLabel, kakaoImageView].forEach {
            kakaoLoginView.addSubview($0)
        }
        
        [appleLoginLabel, appleImageView].forEach {
            appleLoginView.addSubview($0)
        }
        
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
