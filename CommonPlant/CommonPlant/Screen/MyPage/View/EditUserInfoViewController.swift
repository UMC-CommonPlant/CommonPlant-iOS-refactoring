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
import Then

class EditUserInfoViewController: UIViewController, UITextFieldDelegate {
    // MARK: Properties
    let disposeBag = DisposeBag()
    private let viewModel = EditUserInfoViewModel()
    private let maximumCount = 10
    
    // MARK: UI Components
    private let userProfileView = UIView()
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfileGreen")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 83.33 / 2
    }
    private let cameraImageView = UIImageView().then {
        $0.image = UIImage(named: "CameraMark")!
    }
    private let userNickNameTextFiled = UITextField().then {
        $0.text = "커먼플랜트"
        $0.placeholder = "커먼플랜트"
        $0.font = .bodyM1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.tintColor = .black
        $0.clearButtonMode = .whileEditing
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
        $0.autocapitalizationType = .none
        $0.returnKeyType = .done
        $0.clearsOnInsertion = true
    }
    private let underlineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    private let countLabel = UILabel().then {
        $0.font = .bodyB3
        $0.textAlignment = .right
        $0.textColor = .black
        $0.isHidden = true
    }
    private let checkDuplicateButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("중복검사")
        attr.font = .bodyM3
        attr.foregroundColor = .gray6
        config.attributedTitle = attr
        $0.configuration = config
        $0.contentHorizontalAlignment = .center
        $0.backgroundColor = .gray1
        $0.makeRound(radius: 4)
        $0.isHidden = true
    }
    private let messageLabel = UILabel().then {
        $0.font = .captionM2
        $0.textAlignment = .left
    }
    private let doneButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("수정 완료")
        attr.font = .bodyM2
        attr.foregroundColor = .gray3
        config.attributedTitle = attr
        $0.configuration = config
        $0.contentHorizontalAlignment = .center
        $0.backgroundColor = .gray1
        $0.makeRound(radius: 8)
        $0.isEnabled = false
    }
    
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
            make.size.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(83.33)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(6.9)
            make.size.equalTo(23.83)
        }
        
        userNickNameTextFiled.snp.makeConstraints { make in
            make.top.equalTo(userProfileView.snp.bottom).offset(16)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        underlineView.snp.makeConstraints { make in
            make.top.equalTo(userNickNameTextFiled.snp.bottom)
            make.horizontalEdges.equalTo(20)
            make.height.equalTo(1.2)
        }
        
        checkDuplicateButton.snp.makeConstraints { make in
            make.centerY.equalTo(userNickNameTextFiled.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.width.equalTo(73)
            make.height.equalTo(36)
        }
        
        countLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userNickNameTextFiled.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(20)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(43)
            make.horizontalEdges.equalToSuperview().inset(20)
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

