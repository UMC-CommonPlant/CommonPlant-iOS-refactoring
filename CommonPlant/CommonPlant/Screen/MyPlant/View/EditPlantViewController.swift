//
//  EditPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2/12/24.
//

import UIKit
import SnapKit
import Kingfisher

import RxSwift
import RxCocoa

class EditPlantViewController: UIViewController {
    private let viewModel: EditPlantViewModel
    private lazy var input = EditPlantViewModel
        .Input(imageDidTap: plantView.rx.tapGesture().map { _ in }.asObservable(),
               changedImage: plantImageView.rx.imageChanged.map { [weak self] currentImage in
            guard let self, let initialImage = initialImage else { return false }
            
            return currentImage?.pngData() != initialImage.pngData()
        },
               editingNickname: nicknameTextField.rx.text.orEmpty.asObservable(),
               completeBtnDidTap: completeButton.rx.tap.map { [weak self] _ in
            guard let self, let plantImg = plantImageView.image, let nickname = nicknameTextField.text else {
                return PutPlantRequest(plantIdx: 0, nickname: "", imageData: Data())
            }
            
            let data: Data = plantImg.jpegData(compressionQuality: 1.0) ?? Data()
            
            return PutPlantRequest(plantIdx: plantIdx, nickname: nickname, imageData: data)
        }.asObservable())
    
    private lazy var output = viewModel.transform(input: input)
    private let selectNewImage = PublishRelay<Void>()
    private let changeToDefaultImage = PublishRelay<Void>()
    private var initialImage: UIImage?
    
    private let plantView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var plantImageView: UIImageView = {
        let view = UIImageView()
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
    private let nicknameTextField: UITextField = {
        let tf = UITextField()
        tf.font = .bodyM1
        tf.textColor = .black
        tf.tintColor = .black
        tf.clearButtonMode = .whileEditing
        tf.returnKeyType = .done
        return tf
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    private let nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.font = .captionB1
        label.textColor = .gray5
        label.textAlignment = .right
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
    
    private let plantIdx: Int
    var completionHandler: ((Int, String, UIImage) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setConstraints()
        bind()
    }
    
    init(_ plantIdx: Int, plantNickname: String, imgURL: String) {
        self.viewModel = EditPlantViewModel(plantIdx, plantNickname: plantNickname, imgURL: imgURL)
        self.plantIdx = plantIdx
        super.init(nibName: nil, bundle: nil)
        
        nicknameTextField.text = plantNickname
        nicknameTextField.placeholder = plantNickname
        
        nicknameCountLabel.text = "\(plantNickname.count)/10"
        nicknameCountLabel.partiallyChanged(targetString: "/10", font: .captionM1, color: .gray5)
        
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if let imgURL = URL(string: imgURL) {
                plantImageView.kf.setImage(with: imgURL) { [weak self] _ in
                    guard let self else { return }
                    initialImage = plantImageView.image
                }
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "식물 수정"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
    }
    
    func bind() {
        output.showImagePicker.drive { [weak self] _ in
            guard let self = self else { return }
            
            ImagePickerViewModel.shared.checkPermissionState() { state in
                DispatchQueue.main.async {
                    switch state {
                    case .denied:
                        self.moveToSetting()
                    case .authorized:
                        ImagePickerViewController.shared.showPhotoPicker(viewController: self)
                        
                        ImagePickerViewController.shared.didSelectImage = { [weak self] imageString in
                            guard let self else { return }
                            plantImageView.kf.setImage(with: URL(string: imageString))
                        }
                        
                    case .limited:
                        let imagePickerVC = ImagePickerViewController()
                        
                        self.present(imagePickerVC, animated: true)
                        
                        imagePickerVC.didSelectImage = { [weak self] imageString in
                            guard let self else { return }
                            plantImageView.kf.setImage(with: URL(string: imageString))
                        }
                    default:
                        print("\(state)")
                    }
                }
            }
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
        
        output.popToPreviousView.drive { [weak self] _ in
            guard let self else { return }
            guard let nickname = nicknameTextField.text, let image = plantImageView.image else { return }
            
            completionHandler?(plantIdx, nickname, image)
            navigationController?.popViewController(animated: true)
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

extension Reactive where Base: UIImageView {
    var imageChanged: Observable<UIImage?> {
        return self.observe(UIImage.self, "image")
    }
}
