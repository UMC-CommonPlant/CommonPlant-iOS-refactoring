//
//  EditPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2/12/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class EditPlantViewController: UIViewController {
    private let viewModel = EditPlantViewModel()
    private lazy var input = EditPlantViewModel
        .Input(imageDidTap: plantView.rx.tapGesture().map { _ in }.asObservable(),
               selectedNewImage: selectNewImage.asObservable(),
               selectedDefaultImage: changeToDefaultImage.asObservable(),
               changedImage: currentImage.map { [weak self] currentImage in
            guard let initialImage = self?.initialImage.value else { return nil }
            return currentImage?.pngData() != initialImage.pngData()
        },
               editingNickname: nicknameTextField.rx.text.orEmpty.asObservable())
    private lazy var output = viewModel.transform(input: input)
    private let selectNewImage = PublishRelay<Void>()
    private let changeToDefaultImage = PublishRelay<Void>()
    private let currentImage = PublishRelay<UIImage?>()
    private let initialImage = BehaviorRelay<UIImage?>(value: nil)
    
    private let plantView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var plantImageView: UIImageView = {
        let view = UIImageView()
        if let imageUrl = URL(string: viewModel.initPlant.plantImage) {
            view.load(url: imageUrl) {
                self.initialImage.accept(view.image)
            }
        } else {
            view.image = UIImage(named: "AddPlant")
            initialImage.accept(UIImage(named: "AddPlant"))
        }
        view.makeRound(radius: 16)
        return view
    }()
    private let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "CameraMark")
        return view
    }()
    private let nicknameView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .bodyM1
        tf.text = viewModel.initPlant.plantName
        tf.textColor = .black
        tf.tintColor = .black
        tf.placeholder = viewModel.initPlant.plantName
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        return tf
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private lazy var nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(viewModel.initPlant.plantName.count)/10"
        label.font = .captionB1
        label.textColor = .gray5
        label.textAlignment = .right
        label.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
        return label
    }()
    private let completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("완료")
        attribute.font = .bodyM3
        config.attributedTitle = attribute
        config.baseForegroundColor = .gray3
        button.configuration = config
        button.backgroundColor = .gray1
        button.makeRound(radius: 8)
        button.isEnabled = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setConstraints()
        bind()
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "식물 수정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func bind() {
        output.showImgSettingAlert.drive { [weak self] _ in
            guard let self = self else { return }
            
            showImageSettingAlert { state in
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
                            
                            plantImageView.load(url: URL(string: imageString)!) {
                                self.currentImage.accept(self.plantImageView.image)
                            }
                        }
                    case .limited:
                        let imagePickerVC = ImagePickerViewController()
                        
                        self.present(imagePickerVC, animated: true)
                        
                        imagePickerVC.didSelectImage = { [weak self] imageString in
                            guard self != nil else { return }
                            self?.plantImageView.load(url: URL(string: imageString)!) {
                                self?.currentImage.accept(self?.plantImageView.image)
                            }
                        }
                    default:
                        print("\(state)")
                    }
                }
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.changeDefaultImage.drive { [weak self] _ in
            guard let self = self else { return }
            
            plantImageView.image = UIImage(named: "AddPlant")
            currentImage.accept(UIImage(named: "AddPlant"))
        }.disposed(by: viewModel.disposeBag)
        
        output.newNickname.drive { [weak self] nickname in
            guard let self = self else { return }
            
            nicknameTextField.text = nickname
            nicknameCountLabel.text = "\(nickname.count)/10"
            nicknameCountLabel.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
            nicknameCountLabel.textColor = nickname.count > 0 ? .black : .gray5
            underlineView.backgroundColor = nickname.count > 0 ? .black : .gray2
        }.disposed(by: viewModel.disposeBag)
        
        output.buttonState.drive { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .enable:
                completeButton.isEnabled = true
                completeButton.backgroundColor = .seaGreenDark1
                completeButton.configuration?.baseForegroundColor = .white
            case .disable:
                completeButton.isEnabled = false
                completeButton.backgroundColor = .gray1
                completeButton.configuration?.baseForegroundColor = .gray3
            case .onClick:
                completeButton.backgroundColor = .seaGreenDark3
                completeButton.configuration?.baseForegroundColor = .white
            }
        }.disposed(by: viewModel.disposeBag)
    }
    
    func setConstraints() {
        [plantView, nicknameView, completeButton].forEach {
            view.addSubview($0)
        }
        
        [plantImageView, cameraImageView].forEach {
            plantView.addSubview($0)
        }
        
        [nicknameTextField, nicknameCountLabel, underlineView].forEach {
            nicknameView.addSubview($0)
        }
        
        plantView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.width.height.equalTo(120)
        }
        
        plantImageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(100)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        nicknameView.snp.makeConstraints { make in
            make.top.equalTo(plantView.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalTo(nicknameCountLabel.snp.leading).offset(-5)
        }
        
        nicknameCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(nicknameTextField.snp.trailing).offset(5)
            make.trailing.equalToSuperview()
        }
        
        underlineView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(48)
        }
    }
}
