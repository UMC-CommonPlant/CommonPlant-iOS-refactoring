//
//  SignUpViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/26.
//

import UIKit
import RxSwift
import RxCocoa
import PhotosUI

class SignUpViewController: UIViewController {
    // MARK: Properties
    private let viewModel = SignUpViewModel()
    private lazy var privacyVC = PrivacyViewController(viewModel.privacyVM)
    private let email: String
    private let provider: String
    
    private lazy var input = SignUpViewModel.Input(
        backBtnDidTap: backButton.rx.tap.asObservable(),
        profileImgDidTap: profileImageView.rx.tapGesture().map{ _ in}.asObservable(),
        selectedNewImage: selectNewImage.asObservable(),
        selectedDefaultImage: changeToDefaultImage.asObservable(),
        editingNickname: userNickNameTextFiled.rx.text.orEmpty.asObservable(),
        endEditingNickname: userNickNameTextFiled.rx.controlEvent(.editingDidEnd).asObservable(),
        duplicateBtnDidTap: checkDuplicateButton.rx.tapGesture().map{ _ in self.userNickNameTextFiled.text ?? "" }.asObservable(),
        privacyDidTap: privacyView.rx.tapGesture().map { _ in }.asObservable(),
        submitBtnDidTap: submitButton.rx.tap.map { _ in
            var data: Data?
            
            if self.profileImageView.image == UIImage(named: "ProfileGreen") {
                data = nil
            } else {
                data = self.profileImageView.image?.jpegData(compressionQuality: 1.0)
            }
            return (self.email, self.provider, data) }.asObservable())
    private lazy var output = viewModel.transform(input: input)
    private let selectNewImage = PublishRelay<Void>()
    private let changeToDefaultImage = PublishRelay<Void>()
    
    private let maximumCount = 10
    
    // MARK: UI Components
    private var navigationBarView = UIView()
    private var backButton: UIButton = {
        let button = UIButton()
        var backBtnConfig = UIButton.Configuration.plain()
        backBtnConfig.image = UIImage(named: "Back")
        button.configuration = backBtnConfig
        return button
    }()
    private var userProfileView = UIView()
    private var profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ProfileGreen")
        view.makeRound(radius: 41.6)
        view.contentMode = .scaleAspectFill
        return view
    }()
    private var addImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Add")
        return view
    }()
    private var userNickNameTextFiled: UITextField = {
        let field = UITextField()
        field.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray3 as Any, NSAttributedString.Key.font: UIFont.bodyM1])
        field.font = .bodyM1
        field.textAlignment = .left
        field.textColor = .black
        field.tintColor = .black
        field.clearButtonMode = .whileEditing
        field.autocorrectionType = .no
        field.spellCheckingType = .no
        field.autocapitalizationType = .none
        field.returnKeyType = .done
        field.clearsOnInsertion = true
        return field
    }()
    private var underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private var countLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB3
        label.textAlignment = .right
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    private var checkDuplicateButton: UIButton = {
        let button = UIButton()
        var btnConfig = UIButton.Configuration.plain()
        var btnAttr = AttributedString.init("중복검사")
        btnAttr.font = .bodyM3
        btnAttr.foregroundColor = .gray6
        btnConfig.attributedTitle = btnAttr
        
        button.configuration = btnConfig
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .gray1
        button.makeRound(radius: 4)
        button.isHidden = true
        return button
    }()
    private var messageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .captionM2
        label.textAlignment = .left
        return label
    }()
    private var privacyView = UIView()
    private var checkButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "UnselectedGray")
        return view
    }()
    private var privacyPolicyLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 이용 약관 동의"
        label.font = .bodyM2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private var showButton: UIButton = {
        let button = UIButton()
        var btnConfig = UIButton.Configuration.plain()
        var btnAttr = AttributedString.init("보기")
        btnAttr.font = .bodyB2
        btnAttr.foregroundColor = .gray4
        btnConfig.attributedTitle = btnAttr
        btnConfig.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        button.configuration = btnConfig
        return button
    }()
    private var submitButton: UIButton = {
        let button = UIButton()
        var btnConfig = UIButton.Configuration.plain()
        var btnAttr = AttributedString.init("완료")
        btnAttr.font = .bodyM2
        btnConfig.attributedTitle = btnAttr
        btnConfig.baseForegroundColor = .gray4
        button.configuration = btnConfig
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .gray1
        button.makeRound(radius: 8)
        button.isEnabled = false
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        setConstraints()
    }
    
    init(email: String, provider: String) {
        self.email = email
        self.provider = provider
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom Method
    func setHierarchy() {
        [navigationBarView, userProfileView, userNickNameTextFiled, underlineView, countLabel, messageLabel, checkDuplicateButton, privacyView, submitButton].forEach {
            view.addSubview($0)
        }
        
        navigationBarView.addSubview(backButton)
        
        [profileImageView, addImageView].forEach {
            userProfileView.addSubview($0)
        }
        
        [checkButton, privacyPolicyLabel, showButton].forEach {
            privacyView.addSubview($0)
        }
    }
    
    func setConstraints() {
        [navigationBarView, userProfileView, userNickNameTextFiled, underlineView, countLabel, messageLabel, checkDuplicateButton, privacyView, submitButton].forEach {
            view.addSubview($0)
        }
        
        navigationBarView.addSubview(backButton)
        
        [profileImageView, addImageView].forEach {
            userProfileView.addSubview($0)
        }
        
        [checkButton, privacyPolicyLabel, showButton].forEach {
            privacyView.addSubview($0)
        }
        
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
            make.bottom.equalTo(submitButton.snp.top).offset(-16)
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
        
        submitButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-43)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
        }
    }
    
    func bind() {
        output.dismissView.drive { [weak self] _ in
            guard let self = self else { return }
            self.dismiss(animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        output.showImgSettingAlert.drive { [weak self] _ in
            guard let self = self else { return }
            
            self.showImageSettingAlert { state in
                switch state {
                case .newImage:
                    self.selectNewImage.accept(())
                case .defaultImage:
                    self.changeToDefaultImage.accept(())
                case .cancle:
                    break
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.showImagePicker.drive { [weak self] _ in
            guard let self = self else { return }
            
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
                            guard let self = self else { return }
                            profileImageView.load(url: URL(string: imageString)!)
                        }
                    case .limited:
                        let imagePickerVC = ImagePickerViewController()
                        
                        self.present(imagePickerVC, animated: true)
                        
                        imagePickerVC.didSelectImage = { [weak self] imageString in
                            guard self != nil else { return }
                            self?.profileImageView.load(url: URL(string: imageString)!)
                        }
                    default:
                        print("\(state)")
                    }
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.changeDefaultImage.drive { [weak self] _ in
            guard let self = self else { return }
            
            profileImageView.image = UIImage(named: "ProfileGreen")
        }.disposed(by: viewModel.disposeBag)
        
        output.nicknameText.drive { [weak self] nickname in
            guard let self = self else { return }
            
            userNickNameTextFiled.text = nickname
            countLabel.isHidden = false
            countLabel.text = "\(nickname.count)/\(maximumCount)"
            countLabel.textColor = nickname.count > 0 ? .black : .gray5
            countLabel.partiallyChanged(targetString: "/\(maximumCount)", font: .bodyM3, color: .gray5)
        }.disposed(by: viewModel.disposeBag)
        
        output.showDuplicateBtn.drive { [weak self] _ in
            guard let self = self else { return }
            
            messageLabel.isHidden = true
            countLabel.isHidden = true
            checkDuplicateButton.isHidden = false
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.nicknameState.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .duplicate:
                underlineView.backgroundColor = .activeRed
                messageLabel.textColor = .activeRed
                messageLabel.text = "중복된 닉네임입니다"
            case .unavailable:
                underlineView.backgroundColor = .activeRed
                messageLabel.textColor = .activeRed
                messageLabel.text = "2~10자의 영문, 한글, 숫자를 입력해주세요"
            case .available:
                underlineView.backgroundColor = .activeBlue
                messageLabel.textColor = .activeBlue
                messageLabel.text = "사용 가능한 닉네임입니다"
            }
            
            messageLabel.isHidden = false
            countLabel.isHidden = true
            checkDuplicateButton.isHidden = true
        }).disposed(by: viewModel.disposeBag)
        
        output.showPrivacyView.drive { [weak self] _ in
            guard let self = self else { return }
            
            self.present(privacyVC, animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.isAgreePolicy.subscribe { [weak self] isAgree in
            guard let self = self else { return }
            
            checkButton.image = isAgree ? UIImage(named: "SelectedGray") : UIImage(named: "UnselectedGray")
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.submitBtnState.bind { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .enable:
                submitButton.isEnabled = true
                submitButton.layer.borderColor = UIColor.seaGreenDark1?.cgColor
                submitButton.layer.borderWidth = 1
                submitButton.configuration?.baseForegroundColor = .seaGreenDark1
                submitButton.backgroundColor = .white
            case .disable:
                submitButton.isEnabled = false
                submitButton.layer.borderColor = UIColor.gray1?.cgColor
                submitButton.backgroundColor = .gray1
                submitButton.setTitleColor(.yellow, for: .normal)
                submitButton.configuration?.baseForegroundColor = .gray3
            case .onClick:
                submitButton.backgroundColor = .seaGreen
            }
            
        }.disposed(by: viewModel.disposeBag)
        
        userNickNameTextFiled.rx.controlEvent(.editingDidBegin).subscribe { [weak self] _ in
            guard let self = self else { return }
            
            messageLabel.isHidden = true
            checkDuplicateButton.isHidden = true
            underlineView.backgroundColor = .gray2
        }.disposed(by: viewModel.disposeBag)
    }
}
