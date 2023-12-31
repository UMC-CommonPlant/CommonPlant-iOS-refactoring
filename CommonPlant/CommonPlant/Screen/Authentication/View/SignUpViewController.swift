//
//  SignUpViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import RxSwift
import PhotosUI

class SignUpViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    var disposeBag = DisposeBag()
    let maximumCount = 10
    
    // MARK: UI Components
    var navigationBarView = UIView()
    var backButton = UIButton()
    var userProfileView = UIView()
    var profileImageView = UIImageView()
    var addImageView = UIImageView()
    var userNickNameTextFiled = UITextField()
    var underlineView = UIView()
    var countLabel = UILabel()
    var checkDuplicateButton = UIButton()
    var messageLabel = UILabel()
    var privacyView = UIView()
    var checkButton = UIImageView()
    var privacyPolicyLabel = UILabel()
    var showButton = UIButton()
    var doneButton = UIButton()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        SignUpViewModel.shared.nickNameState.accept(.normal)
        SignUpViewModel.shared.userEmail.onNext("")
        SignUpViewModel.shared.userProfileImgURL.onNext("")
        SignUpViewModel.shared.nickNameState.accept(.normal)
        SignUpViewModel.shared.textCount.accept(0)
        SignUpViewModel.shared.isAgreePolicy.accept(false)
    }
    
    // MARK: Custom Method
    func setUI() {
        view.backgroundColor = .white
        
        var backBtnConfig = UIButton.Configuration.plain()
        var checkDupleBtnConfig = UIButton.Configuration.plain()
        var doneBtnConfig = UIButton.Configuration.plain()
        var showBtnConfig = UIButton.Configuration.plain()
        
        backBtnConfig.image = UIImage(named: "Back")
        backButton.configuration = backBtnConfig
        
        addImageView.image = UIImage(named: "Add")
        
        userNickNameTextFiled.delegate = self
        userNickNameTextFiled.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 as Any, NSAttributedString.Key.font: UIFont.bodyM1])
        userNickNameTextFiled.font = .bodyM1
        userNickNameTextFiled.textAlignment = .left
        userNickNameTextFiled.textColor = .black
        userNickNameTextFiled.tintColor = .black
        userNickNameTextFiled.clearButtonMode = .whileEditing
        userNickNameTextFiled.autocorrectionType = .no
        userNickNameTextFiled.spellCheckingType = .no
        userNickNameTextFiled.autocapitalizationType = .none
        userNickNameTextFiled.returnKeyType = .done
        userNickNameTextFiled.clearsOnInsertion = true
        
        var checkDupleAttr = AttributedString.init("중복검사")
        checkDupleAttr.font = .bodyM3
        checkDupleAttr.foregroundColor = .gray6
        checkDupleBtnConfig.attributedTitle = checkDupleAttr
        
        checkDuplicateButton.configuration = checkDupleBtnConfig
        checkDuplicateButton.contentHorizontalAlignment = .center
        checkDuplicateButton.backgroundColor = .gray1
        checkDuplicateButton.makeRound(radius: 4)
        checkDuplicateButton.isHidden = true
        
        countLabel.font = .bodyB3
        countLabel.textAlignment = .right
        countLabel.textColor = .black
        countLabel.isHidden = true
        
        messageLabel.font = .captionM2
        messageLabel.textAlignment = .left
        
        privacyPolicyLabel.text = "개인정보 이용 약관 동의"
        privacyPolicyLabel.font = .bodyM2
        privacyPolicyLabel.textAlignment = .left
        privacyPolicyLabel.textColor = .black
        
        var showAttr = AttributedString.init("보기")
        showAttr.font = .bodyB2
        showAttr.foregroundColor = .gray4
        showBtnConfig.attributedTitle = showAttr
        showBtnConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        showButton.configuration = showBtnConfig
        
        var doneAttr = AttributedString.init("완료")
        doneAttr.font = .bodyM2
        doneButton.contentHorizontalAlignment = .center
        doneButton.makeRound(radius: 8)
        
        SignUpViewModel.shared.userProfileImgURL.subscribe(onNext: { [weak self] imageURL in
            guard let self = self else { return }
            if imageURL.isEmpty {
                profileImageView.image = UIImage(named: "ProfileGreen")
            } else {
                if let imageURL = URL(string: imageURL) {
                    DispatchQueue.main.async {
                        self.profileImageView.load(url: imageURL)
                        self.profileImageView.contentMode = .scaleAspectFill
                        self.profileImageView.makeRound(radius: self.profileImageView.frame.height/2)
                    }
                }
            }
        }).disposed(by: disposeBag)
        
        SignUpViewModel.shared.isAgreePolicy.subscribe(onNext: { [weak self] isAgree in
            guard let self = self else { return }
            if isAgree {
                checkButton.image = UIImage(named: "SelectedGray")
            } else {
                checkButton.image = UIImage(named: "UnselectedGray")
            }
        }).disposed(by: disposeBag)
        
        SignUpViewModel.shared.nickNameState.map { state -> UIColor in
            self.messageLabel.isHidden = false
            self.messageLabel.text = state.rawValue
            
            switch state {
            case .normal:
                return .gray2!
            case .unusable:
                return .activeRed!
            case .usable:
                return .activeBlue!
            }
        }.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            
            messageLabel.textColor = color
            underlineView.backgroundColor = color
        }).disposed(by: disposeBag)
        
        SignUpViewModel.shared.textCount.subscribe(onNext: { [weak self] count in
            guard let self = self else { return }
            countLabel.text = "\(count)/\(maximumCount)"
            countLabel.partiallyChanged(targetString: "/\(maximumCount)", font: .bodyM3, color: .gray5)
        }).disposed(by: disposeBag)
        
        Observable.combineLatest(SignUpViewModel.shared.nickNameState, SignUpViewModel.shared.isAgreePolicy) { nickNameState, isAgreePolicy in
            return nickNameState == .usable && isAgreePolicy
        }
        .map { state -> (UIColor, UIColor, Bool) in
            state ? (.white, .seaGreenDark1!, true) : (.gray3!, .gray1!, false)
        }
        .subscribe(onNext: { [weak self] foregroundColor, backgroundColor, isEnable in
            guard let self = self else { return }
            
            doneAttr.foregroundColor = foregroundColor
            doneBtnConfig.attributedTitle = doneAttr
            
            doneButton.configuration = doneBtnConfig
            doneButton.backgroundColor = backgroundColor
            doneButton.isEnabled = isEnable
        }).disposed(by: disposeBag)
    }
    
    func setHierarchy() {
        view.addSubview(navigationBarView)
        view.addSubview(userProfileView)
        view.addSubview(userNickNameTextFiled)
        view.addSubview(underlineView)
        view.addSubview(countLabel)
        view.addSubview(messageLabel)
        view.addSubview(checkDuplicateButton)
        view.addSubview(privacyView)
        view.addSubview(doneButton)
        
        navigationBarView.addSubview(backButton)
        
        userProfileView.addSubview(profileImageView)
        userProfileView.addSubview(addImageView)
        
        privacyView.addSubview(checkButton)
        privacyView.addSubview(privacyPolicyLabel)
        privacyView.addSubview(showButton)
    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(13)
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        userProfileView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(83.33)
        }
        
        addImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(69.27)
            make.left.equalToSuperview().offset(69.49)
            make.width.height.equalTo(23.83)
        }
        
        userNickNameTextFiled.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-61)
            make.height.equalTo(56)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(userNickNameTextFiled.snp.bottom)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(1.2)
        }
        
        checkDuplicateButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNickNameTextFiled.snp.centerY)
            make.right.equalTo(-20)
            make.width.equalTo(73)
            make.height.equalTo(36)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userNickNameTextFiled.snp.centerY)
            make.right.equalTo(-20)
            make.height.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(8)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        privacyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(doneButton.snp.top).offset(-16)
            make.height.equalTo(56)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(24)
        }
        
        privacyPolicyLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalTo(checkButton.snp.trailing).offset(12)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        showButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalTo(privacyPolicyLabel.snp.trailing).offset(8)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-43)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
        }
    }
    
    func setAction() {
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
        
        checkDuplicateButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            checkDuplicateButton.isHidden = true
            
            guard let text = userNickNameTextFiled.text else { return }
            if text.count > 1 && text.count < 10 {
                SignUpViewModel.shared.nickNameState.accept(.usable)
            } else {
                SignUpViewModel.shared.nickNameState.accept(.unusable)
            }
            
            view.endEditing(true)
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: {
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            
            let mainVC = MainTabBarController()
            
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window?.rootViewController = mainVC
            }, completion: nil)
        }).disposed(by: disposeBag)
        
        privacyView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let nextVC = PrivacyViewController()
                self.present(nextVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            doneButton.backgroundColor = .seaGreenDark3
        }).disposed(by: disposeBag)
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [self] _ in
                self.showImageSettingAlert { selectedOption in
                    switch selectedOption {
                    case .newImage:
                        ImagePickerViewModel.shared.checkPermissionState() { state in
                            DispatchQueue.main.async {
                                switch state {
                                case .denied:
                                    self.moveToSetting()
                                case .authorized:
                                    DispatchQueue.main.async { [weak self] in
                                        guard let self = self else { return }
                                        ImagePickerViewController.shared.showPhotoPicker(viewController: self)
                                    }
                                        
                                    ImagePickerViewController.shared.didSelectImage = { [weak self] imageString in
                                        guard self != nil else { return }
                                        SignUpViewModel.shared.userProfileImgURL.onNext(imageString)
                                    }
                                case .limited:
                                    let imagePickerVC = ImagePickerViewController()
                                    
                                    self.present(imagePickerVC, animated: true)
                                    
                                    imagePickerVC.didSelectImage = { [weak self] imageString in
                                        guard self != nil else { return }
                                        SignUpViewModel.shared.userProfileImgURL.onNext(imageString)
                                    }
                                default:
                                    print("\(state)")
                                }

                            }
                        }
                    case .defaultImage:
                        SignUpViewModel.shared.userProfileImgURL.onNext("")
                    case .cancle:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.text.orEmpty.map { text -> Int in
                return text.count
            }
            .subscribe(onNext: { count in
                SignUpViewModel.shared.textCount.accept(count)
            }).disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                SignUpViewModel.shared.nickNameState.accept(.normal)
                SignUpViewModel.shared.textCount.accept(0)
                
                userNickNameTextFiled.placeholder = ""
                userNickNameTextFiled.text = ""
                
                underlineView.backgroundColor = .black
                
                messageLabel.isHidden = true
                countLabel.isHidden = false
                checkDuplicateButton.isHidden = true
            }).disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.controlEvent(.editingDidEndOnExit)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                checkDuplicateButton.isHidden = false
                countLabel.isHidden = true
                underlineView.backgroundColor = .gray2
                userNickNameTextFiled.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
}
