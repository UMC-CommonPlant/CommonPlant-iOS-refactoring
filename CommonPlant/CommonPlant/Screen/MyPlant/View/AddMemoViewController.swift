//
//  AddMemoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 12/5/23.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class AddMemoViewController: UIViewController {
    // MARK: - Properties
    let viewModel = MemoViewModel()
    let imageChanged = BehaviorRelay<UIImage?>(value: nil)
    lazy var isChangedData = Observable.combineLatest(imageChanged, contentTextView.rx.text.orEmpty)
        .map { image, text in
            return image != self.initImage.image || text != self.memo?.content
        }
    private lazy var input = MemoViewModel.Input(cameraButtonDidtap: cameraButtonView.rx.tapGesture().map { _ in }.asObservable(), imageChanged: imageChanged.map { _ in }.asObservable(), isChaged: isChangedData, deleteButtonDidTap: deleteButton.rx.tap.asObservable(), completeButtonDidTap: completeButton.rx.tap.asObservable(), contentTextView: contentTextView.rx.text.orEmpty.asObservable(), hideKeyboard: view.rx.tapGesture().map { _ in }.asObservable())
    private lazy var output = viewModel.transform(input: input)
    let memo: Memo?
    
    // MARK: - UI Components
    let initImage = UIImageView()
    var imageSelectView = UIView()
    let cameraButtonView: UIView = {
        let view = UIView()
        view.makeRound(radius: 8)
        view.layer.borderColor = UIColor.gray2?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Camera")
        return view
    }()
    lazy var selectImageView: UIImageView = {
        let view = UIImageView()
        if let urlString = memo?.imgURL, let url = URL(string: urlString) {
            view.load(url: url) {
                self.initImage.image = view.image
            }
        }
        view.contentMode = .scaleAspectFill
        view.makeRound(radius: 8)
        
        return view
    }()
    lazy var deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Delete")
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        button.configuration = config
        button.isHidden = memo?.imgURL == nil ? true : false
        return button
    }()
    lazy var imageCountLabel: UILabel = {
        let label = UILabel()
        let count = memo?.imgURL == nil ? 0 : 1
        label.text = "\(count)/1"
        label.textColor = .gray5
        label.font = .bodyB3
        label.partiallyChanged(targetString: "/1", font: .bodyM3, color: .gray5)
        return label
    }()
    lazy var contentTextView: UITextView = {
        let view = UITextView()
        view.text = memo?.content
        view.textColor = .gray6
        view.tintColor = .gray6
        view.font = .bodyM2
        view.textAlignment = .left
        view.returnKeyType = .done
        view.textContainerInset = .zero
        view.backgroundColor = .clear
        view.isScrollEnabled = false
        view.isEditable = true
        return view
    }()
    lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        let content = memo?.content
        label.text = content == nil ? "메모 내용을 입력해 주세요" : ""
        label.textColor = .gray3
        label.font = .bodyM1
        label.textAlignment = .left
        return label
    }()
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    lazy var textCountLabel: UILabel = {
        let label = UILabel()
        let count = memo?.content.count ?? 0
        label.text = "\(count)/200"
        label.textColor = .gray5
        label.font = .bodyB3
        label.partiallyChanged(targetString: "/200", font: .bodyM3, color: .gray5)
        return label
    }()
    let completeButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("완료")
        attribute.font = .bodyM2
        config.attributedTitle = attribute
        config.baseForegroundColor = .gray3
        button.configuration = config
        button.backgroundColor = .gray1
        button.isEnabled = false
        button.makeRound(radius: 8)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setHierarchy()
        setConstraints()
        bind()
    }
    
    init(memo: Memo) {
        self.memo = memo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        output.buttonState.drive { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .enable:
                completeButton.backgroundColor = .seaGreenDark1
                completeButton.configuration?.baseForegroundColor = .white
                completeButton.isEnabled = true
            case .disable:
                completeButton.backgroundColor = .gray1
                completeButton.configuration?.baseForegroundColor = .gray3
                completeButton.isEnabled = false
            case .onClick:
                completeButton.backgroundColor = .seaGreenDark3
                completeButton.configuration?.baseForegroundColor = .white
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.contentTextView.drive { [weak self] text in
            guard let self = self else { return }
            self.placeholderLabel.text = text.isEmpty ? " 메모 내용을 입력해 주세요" : ""
            self.contentTextView.text = text
            self.textCountLabel.text = "\(text.count)/200"
            self.textCountLabel.partiallyChanged(targetString: "/200", font: .bodyM3, color: .gray5)
            let size = CGSize(width: self.contentTextView.frame.width, height: .infinity)
            self.contentTextView.sizeThatFits(size)
        }.disposed(by: viewModel.disposeBag)
        
        output.endEditing.drive { [weak self] isEnd in
            guard let self = self else { return }
            
            view.endEditing(isEnd)
        }.disposed(by: viewModel.disposeBag)
        
        output.selectImageChanged.drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            updateImageCountLabel(selectImageView.image == nil ? 0 : 1)
            deleteButton.isHidden = selectImageView.image == nil
        }).disposed(by: viewModel.disposeBag)
        
        output.deleteImage.drive { [weak self] _ in
            guard let self = self else { return }
            
            updateImageCountLabel(0)
            deleteButton.isHidden = true
            selectImageView.image = nil
            imageChanged.accept(nil)
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
                            selectImageView.load(url: URL(string: imageString)!) {
                                self.imageChanged.accept(self.selectImageView.image)
                            }
                        }
                    case .limited:
                        let imagePickerVC = ImagePickerViewController()
                        
                        self.present(imagePickerVC, animated: true)
                        
                        imagePickerVC.didSelectImage = { [weak self] imageString in
                            guard self != nil else { return }
                            self?.selectImageView.load(url: URL(string: imageString)!) {
                                self?.imageChanged.accept(self?.selectImageView.image)
                            }
                        }
                    default:
                        print("\(state)")
                    }
                }
            }
        }.disposed(by: viewModel.disposeBag)
    }
    
    func setHierarchy() {
        [imageSelectView, placeholderLabel, contentTextView, underLineView, textCountLabel, completeButton].forEach {
            view.addSubview($0)
        }
        
        [cameraButtonView, selectImageView, deleteButton].forEach {
            imageSelectView.addSubview($0)
        }
        
        [cameraImageView, imageCountLabel].forEach {
            cameraButtonView.addSubview($0)
        }
    }
    
    func setConstraints() {
        imageSelectView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(105)
        }
        
        cameraButtonView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.top.equalToSuperview().offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        cameraImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            make.height.width.equalTo(32)
        }
        
        imageCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-12)
        }
        
        selectImageView.snp.makeConstraints { make in
            make.height.width.equalTo(80)
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(cameraButtonView.snp.trailing).offset(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.width.equalTo(29)
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(selectImageView.snp.leading).offset(61)
            make.trailing.equalTo(selectImageView.snp.trailing).offset(15)
        }
        
        placeholderLabel.snp.makeConstraints { make in
            make.top.equalTo(imageSelectView.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(22)
        }
        
        contentTextView.snp.makeConstraints { make in
            make.top.equalTo(placeholderLabel.snp.top)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(placeholderLabel.snp.height).priority(.low)
        }
        
        underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(contentTextView.textInputView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        textCountLabel.snp.makeConstraints { make in
            make.top.equalTo(underLineView.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            make.height.equalTo(48)
        }
    }
    
    func updateImageCountLabel(_ count: Int) {
        imageCountLabel.text = "\(count)/1"
        imageCountLabel.partiallyChanged(targetString: "/1", font: .bodyM3, color: .gray5)
    }
}
