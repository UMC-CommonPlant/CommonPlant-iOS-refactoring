//
//  EditPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2/12/24.
//

import UIKit
import SnapKit

class EditPlantViewController: UIViewController {
    private let viewModel = EditPlantViewModel()
    
    private let plantView: UIView = {
        let view = UIView()
        return view
    }()
    private lazy var plantImageView: UIImageView = {
        let view = UIImageView()
        if let imageUrl = URL(string: viewModel.initPlant.plantImage) {
            view.load(url: imageUrl)
        } else {
            view.image = UIImage(named: "AddPlant")
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
        view.backgroundColor = .black
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
        setConstraints()
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
    }
}
