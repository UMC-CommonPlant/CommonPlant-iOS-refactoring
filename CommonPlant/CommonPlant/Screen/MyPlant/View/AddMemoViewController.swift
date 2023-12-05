//
//  AddMemoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 12/5/23.
//

import UIKit

class AddMemoViewController: UIViewController {
    // MARK: - Properties
    var textCount: Int = 0
    var imageCount: Int = 0
    
    // MARK: - UI Components
    let imageSelectView = UIView()
    let cameraButtonView: UIView = {
        let view = UIView()
        view.makeRound(radius: 8)
        view.layer.borderColor = UIColor.gray1?.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let cameraImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Camera")
        return view
    }()
    let imageView = UIImageView()
    let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Camera")
        config.imagePadding = 10
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
        textfield.attributedPlaceholder = NSAttributedString(string: "메모 내용을 입력해 주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray3 as Any])
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
        config.background.cornerRadius = 8
        button.configuration = config
        button.backgroundColor = .gray1
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
