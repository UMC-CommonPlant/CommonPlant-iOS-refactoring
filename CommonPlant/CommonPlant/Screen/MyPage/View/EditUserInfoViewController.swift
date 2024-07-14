//
//  EditUserInfoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/09.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import PhotosUI

class EditUserInfoViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    let disposeBag = DisposeBag()
    let viewModel = EditUserInfoViewModel()
    let maximumCount = 10
    
    // MARK: UI Components
    let userProfileView = UIView()
    let profileImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ProfileGreen")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 83.33 / 2
        return view
    }()
    let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "CameraMark")!
        return view
    }()
    let userNickNameTextFiled: UITextField = {
        let field = UITextField()
        field.text = "커먼플랜트"
        field.placeholder = "커먼플랜트"
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
    let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB3
        label.textAlignment = .right
        label.textColor = .black
        label.isHidden = true
        return label
    }()
    let checkDuplicateButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("중복검사")
        attr.font = .bodyM3
        attr.foregroundColor = .gray6
        config.attributedTitle = attr
        button.configuration = config
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .gray1
        button.makeRound(radius: 4)
        button.isHidden = true
        return button
    }()
    let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .captionM2
        label.textAlignment = .left
        return label
    }()
    let doneButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("수정 완료")
        attr.font = .bodyM2
        attr.foregroundColor = .gray3
        config.attributedTitle = attr
        button.configuration = config
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
        setNavigationBar()
        setHierarchy()
        setLayout()
        setAction()
    }
    
    // MARK: Custom Method
    func setNavigationBar() {
        navigationItem.title = "회원 정보 수정"
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .gray6
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setHierarchy() {
        view.addSubview(userProfileView)
        view.addSubview(userNickNameTextFiled)
        view.addSubview(underlineView)
        view.addSubview(countLabel)
        view.addSubview(messageLabel)
        view.addSubview(checkDuplicateButton)
        view.addSubview(doneButton)
        
        userProfileView.addSubview(profileImageView)
        userProfileView.addSubview(cameraImageView)
    }
    
    func setLayout() {
        userProfileView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
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
        checkDuplicateButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            checkDuplicateButton.isHidden = true
            
            let state = viewModel.checkNickNameVaild(userNickNameTextFiled)
            viewModel.nickNameState.accept(state)
            
            view.endEditing(true)
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            doneButton.backgroundColor = .seaGreenDark3
        }).disposed(by: disposeBag)
        
        profileImageView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { gesture in
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
                                        guard let self = self else { return }
                                        viewModel.profileImgURL.onNext(imageString)
                                    }
                                case .limited:
                                    let imagePickerVC = ImagePickerViewController()
                                    
                                    self.present(imagePickerVC, animated: true)
                                    
                                    imagePickerVC.didSelectImage = { [weak self] imageString in
                                        guard self != nil else { return }
                                        self?.viewModel.profileImgURL.onNext(imageString)
                                    }
                                default:
                                    print("\(state)")
                                }

                            }
                        }
                    case .defaultImage:
                        self.viewModel.profileImgURL.onNext("")
                    case .cancle:
                        break
                    }
                }
            })
            .disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.text.orEmpty
            .map(viewModel.checkNickNameCount(_:))
            .subscribe(onNext: { [weak self] count in
                guard let self = self else { return }
                viewModel.textCount.accept(count)
            }).disposed(by: disposeBag)
        
        userNickNameTextFiled.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                viewModel.nickNameState.accept(.normal)
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
                    self.viewModel.profileImgState.accept(.usable)
                }
            }
        }
    }
}

