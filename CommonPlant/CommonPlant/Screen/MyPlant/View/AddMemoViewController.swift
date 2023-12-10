//
//  AddMemoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 12/5/23.
//

import UIKit
import RxSwift
import RxCocoa

class AddMemoViewController: UIViewController {
    // MARK: - Properties
    var textCount: Int = 0
    var imageCount: Int = 0
    let viewModel = MemoViewModel()
    lazy var isImageSelected = BehaviorRelay(value: selectImageView.image != nil)
    private lazy var input = MemoViewModel.Input(cameraButtonDidtap: cameraButtonView.rx.tapGesture().map { _ in }.asObservable(), isSelectedImage: isImageSelected.asObservable(), completeButtonDidTap: completeButton.rx.tap.asObservable(), messageTextFieldText: contentTextField.rx.text.orEmpty.asObservable(), messageTextFieldDidTap: contentTextField.rx.controlEvent([.editingChanged, .editingDidEnd]))
    private lazy var output = viewModel.transform(input: input)
    
    // MARK: - UI Components
    let imageSelectView = UIView()
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
    let selectImageView = UIImageView()
    let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Camera")
        config.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        button.configuration = config
        button.isHidden = true
        return button
    }()
    lazy var imageCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(imageCount)/1"
        label.textColor = .gray5
        label.font = .bodyB3
        label.partiallyChanged(targetString: "/1", font: .bodyM3, color: .gray5)
        return label
    }()
    let contentTextField: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .none
        textfield.textColor = .gray6
        textfield.tintColor = .gray6
        textfield.textAlignment = .left
        textfield.font = .bodyM2
        textfield.returnKeyType = .done
        textfield.clearButtonMode = .whileEditing
        textfield.attributedPlaceholder = NSAttributedString(string: "메모 내용을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray3 as Any, NSAttributedString.Key.font : UIFont.bodyM2])
        return textfield
    }()
    let underLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    lazy var textCountLabel: UILabel = {
        let label = UILabel()
        label.text = "\(textCount)/0"
        label.textColor = .gray5
        label.font = .bodyB3
        label.partiallyChanged(targetString: "/0", font: .bodyM3, color: .gray5)
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
    
    func bind() {
        output.buttonState.drive { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .enable:
                completeButton.backgroundColor = .gray1
                completeButton.configuration?.baseForegroundColor = .gray3
                completeButton.isEnabled = true
            case .disable:
                completeButton.backgroundColor = .seaGreenDark1
                completeButton.configuration?.baseForegroundColor = .white
                completeButton.isEnabled = true
            case .click:
                completeButton.backgroundColor = .seaGreenDark3
                completeButton.configuration?.baseForegroundColor = .white
            }
        }.disposed(by: viewModel.disposeBag)
        
        output.imageCount.drive { [weak self] count in
            guard let self = self else { return }
            
            self.imageCountLabel.text = "\(count)/1"
            self.imageCountLabel.partiallyChanged(targetString: "/1", font: .bodyM3, color: .gray5)
            
        }.disposed(by: viewModel.disposeBag)
        
        output.isImageHidden.drive { [weak self] isHidden in
            guard let self = self else { return }
            
            self.deleteButton.isHidden = isHidden
            
        }.disposed(by: viewModel.disposeBag)
        
        output.contentTextMessage.drive { [weak self] text in
            guard let self = self else { return }
            self.contentTextField.text = text
            self.textCountLabel.text = "\(text.count)/200"
            self.textCountLabel.partiallyChanged(targetString: "/200", font: .bodyM3, color: .gray5)
            
        }.disposed(by: viewModel.disposeBag)
        
        output.showImagePicker.drive { [weak self] isShowing in
            guard let self = self else { return }
            print("showing")
            
        }.disposed(by: viewModel.disposeBag)
    }
    
    func setHierarchy() {
        [imageSelectView, contentTextField, underLineView, textCountLabel, completeButton].forEach {
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
            make.leading.equalToSuperview().offset(20)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.height.width.equalTo(29)
            make.top.equalToSuperview().offset(5)
            make.leading.equalTo(selectImageView.snp.leading).offset(61)
            make.trailing.equalTo(selectImageView.snp.trailing).offset(15)
        }
        
        contentTextField.snp.makeConstraints { make in
            make.top.equalTo(imageSelectView.snp.bottom).offset(35)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        underLineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(contentTextField.snp.bottom).offset(15)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 200
        guard let text = textField.text else { return true }
        let newlength = text.count + string.count - range.length
        return newlength < maxLength
    }
}
