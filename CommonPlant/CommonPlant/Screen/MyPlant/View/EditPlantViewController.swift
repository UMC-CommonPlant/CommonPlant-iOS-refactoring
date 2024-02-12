//
//  EditPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2/12/24.
//

import UIKit

class EditPlantViewController: UIViewController {
    private let viewModel = EditPlantViewModel()
    
    private let plantView: UIView = {
        let view = UIView()
        return view
    }()
    private let plantImageView: UIImageView = {
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
    private let nicknameCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/10"
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
    }
}
