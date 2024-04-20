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
    
    private lazy var input = SignUpViewModel.Input(backBtnDidTap: backButton.rx.tap.asObservable(), profileImgDidTap: profileImageView.rx.tapGesture().map{ _ in}.asObservable(), selectedNewImage: selectNewImage.asObservable(), selectedDefaultImage: changeToDefaultImage.asObservable(), editingNickname: userNickNameTextFiled.rx.text.orEmpty.asObservable(), endEditingNickname: userNickNameTextFiled.rx.controlEvent(.editingDidEnd).asObservable(), duplicateBtnDidTap: checkDuplicateButton.rx.tapGesture().map{ _ in self.userNickNameTextFiled.text ?? "" }.asObservable(), privacyDidTap: privacyView.rx.tapGesture().map { _ in }.asObservable(), submitBtnDidTap: doneButton.rx.tap.asObservable())
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
    private var underlineView = UIView()
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
    private var doneButton: UIButton = {
        let button = UIButton()
        var btnConfig = UIButton.Configuration.plain()
        var btnAttr = AttributedString.init("완료")
        btnAttr.font = .bodyM2
        btnAttr.foregroundColor = .gray4
        btnConfig.attributedTitle = btnAttr
        button.contentHorizontalAlignment = .center
        button.makeRound(radius: 8)
        button.configuration = btnConfig
        return button
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        bind()
        setConstraints()
    }
    
    // MARK: Custom Method
    func setHierarchy() {
        [navigationBarView, userProfileView, userNickNameTextFiled, underlineView, countLabel, messageLabel, checkDuplicateButton, privacyView, doneButton].forEach {
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
        [navigationBarView, userProfileView, userNickNameTextFiled, underlineView, countLabel, messageLabel, checkDuplicateButton, privacyView, doneButton].forEach {
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
        
        output.nicknameState.drive { [weak self] state in
            guard let self = self else { return }
            
            messageLabel.text = state.rawValue
            
            switch state {
            case .normal:
                underlineView.backgroundColor = .gray2
            case .unusable:
                underlineView.backgroundColor = .activeRed
                messageLabel.textColor = .activeRed
            case .usable:
                underlineView.backgroundColor = .activeBlue
                messageLabel.textColor = .activeBlue
            }
            
            messageLabel.isHidden = false
            countLabel.isHidden = true
            checkDuplicateButton.isHidden = true
        }.disposed(by: viewModel.disposeBag)
        
        output.showPrivacyView.drive { [weak self] _ in
            guard let self = self else { return }
            
            self.present(privacyVC, animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        output.submitBtnState.drive { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .enable:
                doneButton.isEnabled = true
                doneButton.layer.borderColor = UIColor.seaGreenDark1?.cgColor
                doneButton.layer.borderWidth = 1
                doneButton.setTitleColor(.seaGreenDark1, for: .normal)
            case .disable:
                doneButton.isEnabled = false
                doneButton.layer.borderColor = UIColor.gray1?.cgColor
                doneButton.backgroundColor = .gray1
                doneButton.setTitleColor(.gray3, for: .normal)
            case .onClick:
                doneButton.backgroundColor = .seaGreen
            }
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.isAgreePolicy.subscribe { [weak self] isAgree in
            guard let self = self else { return }
            
            checkButton.image = isAgree ? UIImage(named: "SelectedGray") : UIImage(named: "UnselectedGray")
        }.disposed(by: viewModel.disposeBag)
        
        userNickNameTextFiled.rx.controlEvent(.editingDidBegin).subscribe { [weak self] _ in
            guard let self = self else { return }
            
            messageLabel.isHidden = true
            checkDuplicateButton.isHidden = true
            underlineView.backgroundColor = .gray2
        }.disposed(by: viewModel.disposeBag)
    }
}
