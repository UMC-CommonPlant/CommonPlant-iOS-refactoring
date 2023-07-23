//
//  EditUserInfoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/09.
//

import UIKit
import RxSwift
import RxCocoa
import RxGesture
import PhotosUI

class EditUserInfoViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    var disposeBag = DisposeBag()
    let viewModel = EditUserInfoViewModel()
    let maximumCount = 10
    
    // MARK: UI Components
    var navigationBarView = UIView()
    var editTitleLabel = UILabel()
    var backButton = UIButton()
    var userProfileView = UIView()
    var profileImageView = UIImageView()
    var profileImage = UIImage()
    var cameraImageView = UIImageView()
    var cameraImage = UIImage()
    var userNickNameTextFiled = UITextField()
    var completeButton = UIButton()
    var underlineView = UIView()
    var countLabel = UILabel()
    var checkDuplicateButton = UIButton()
    var messageLabel = UILabel()
    var doneButton = UIButton()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setAction()
    }
    
    // MARK: Custom Method
    func setUI() {
        view.backgroundColor = .white
        
        var backBtnConfig = UIButton.Configuration.plain()
        var checkDupleBtnConfig = UIButton.Configuration.plain()
        var doneBtnConfig = UIButton.Configuration.plain()
        
        backBtnConfig.image = UIImage(named: "Back")
        backButton.configuration = backBtnConfig
        
        editTitleLabel.text = "회원 정보 수정"
        editTitleLabel.font = .bodyB1
        editTitleLabel.textAlignment = .center
        editTitleLabel.textColor = .black
        
        profileImageView.image = UIImage(named: "ProfileGray")!
        
        cameraImage = UIImage(named: "Camera")!
        cameraImageView.image = cameraImage
        
        MyPageViewModel.shared.userSubject.subscribe(onNext: { [weak self] userInfo in
            self?.userNickNameTextFiled.attributedPlaceholder = NSAttributedString(string: userInfo.nickName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        }).disposed(by: disposeBag)
        userNickNameTextFiled.delegate = self
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
        
        countLabel.text = "\(viewModel.textCount.value)/\(maximumCount)"
        countLabel.font = .bodyB3
        countLabel.textAlignment = .right
        countLabel.textColor = .black
        countLabel.isHidden = true
        countLabel.partiallyChanged(targetString: "/\(maximumCount)", font: .bodyM3, color: .gray5)
        
        var doneAttr = AttributedString.init("수정 완료")
        doneAttr.font = .bodyM2
        doneBtnConfig.attributedTitle = doneAttr
        
        doneButton.configuration = doneBtnConfig
        doneButton.contentHorizontalAlignment = .center
        doneButton.makeRound(radius: 8)
        
        messageLabel.font = .captionM2
        messageLabel.textAlignment = .left
    }
    
    func setHierarchy() {
        view.addSubview(navigationBarView)
        view.addSubview(userProfileView)
        view.addSubview(userNickNameTextFiled)
        view.addSubview(underlineView)
        view.addSubview(countLabel)
        view.addSubview(messageLabel)
        view.addSubview(checkDuplicateButton)
        view.addSubview(doneButton)
        
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(editTitleLabel)
        
        userProfileView.addSubview(profileImageView)
        userProfileView.addSubview(cameraImageView)
    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        editTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
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
        
        cameraImageView.snp.makeConstraints { make in
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
            viewModel.dissmissView(self)
        }).disposed(by: disposeBag)
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
                var configuration = PHPickerConfiguration()
                configuration.filter = .images
                
                let picker = PHPickerViewController(configuration: configuration)
                
                picker.delegate = self
                
                self.present(picker, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        viewModel.buttonState.map { state -> (UIColor, UIColor, UIColor, Bool) in
            self.messageLabel.isHidden = false
            self.messageLabel.text = state.rawValue
            
            switch state {
            case .normal:
                return (.gray2!, .gray3!, .gray1!, false)
            case .unusable:
                return (.activeRed!, .gray3!, .gray1!, false)
            case .usable:
                return (.activeBlue!, .white, .seaGreenDark1!, true)
            }
        }.subscribe(onNext: { [weak self] color, foregroundColor, backgroundColor, isEnable in
            guard let self = self else { return }
            
            var btnConfig = doneButton.configuration
            var btnAttr = btnConfig?.attributedTitle
            
            btnAttr?.foregroundColor = foregroundColor
            btnConfig?.attributedTitle = btnAttr
            
            doneButton.configuration = btnConfig
            doneButton.backgroundColor = backgroundColor
            doneButton.isEnabled = isEnable
            
            messageLabel.textColor = color
            underlineView.backgroundColor = color
        }).disposed(by: disposeBag)
        
        viewModel.textCount.subscribe(onNext: { [weak self] count in
            guard let self = self else { return }
            countLabel.text = "\(count)/\(maximumCount)"
            countLabel.partiallyChanged(targetString: "/\(maximumCount)", font: .bodyM3, color: .gray5)
        }).disposed(by: disposeBag)
        
        checkDuplicateButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            let state = viewModel.checkNickNameVaild(userNickNameTextFiled)
            viewModel.buttonState.accept(state)
            view.endEditing(true)
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            doneButton.backgroundColor = .seaGreenDark3
        }).disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.text.orEmpty
            .map(viewModel.checkNickNameCount(_:))
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                viewModel.textCount.accept(count)
            }).disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                viewModel.buttonState.accept(.normal)
                viewModel.textCount.accept(0)
                
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

extension EditUserInfoViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    self.profileImageView.image = image as? UIImage
                    self.profileImageView.makeRound(radius: self.profileImageView.frame.height/2)
                    self.viewModel.buttonState.accept(.usable)
                    self.underlineView.backgroundColor = .gray2
                    self.messageLabel.text = ""
                }
            }
        }
    }
}

