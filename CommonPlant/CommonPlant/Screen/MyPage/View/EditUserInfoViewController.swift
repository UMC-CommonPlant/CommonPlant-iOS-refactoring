//
//  EditUserInfoViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/09.
//

import UIKit

enum buttonType: String {
    case normal = ""
    case unusable = "2~10자의 닉네임으로 입력해주세요 or 중복된 닉네임입니다"
    case usable = "사용 가능한 닉네임입니다"
}

class EditUserInfoViewController: UIViewController {
    // MARK: Properties
    let maximumCount = 10
    var textCount: Int = 0
    var userNickName: String = "커먼플랜트"
    var buttonState: buttonType = .normal
    
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
    //var resetButton = UIButton()
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
    }
    
    // MARK: Custom Method
    func setUI() {
        view.backgroundColor = .white
        
        var backBtnConfig = UIButton.Configuration.plain()
        var resetBtnConfig = UIButton.Configuration.plain()
        var checkDupleBtnConfig = UIButton.Configuration.plain()
        var doneBtnConfig = UIButton.Configuration.plain()
        
        backBtnConfig.image = UIImage(named: "Back")
        backButton.configuration = backBtnConfig
        
        editTitleLabel.text = "회원 정보 수정"
        editTitleLabel.font = .bodyB1
        editTitleLabel.textAlignment = .center
        editTitleLabel.textColor = .black
        
        profileImage = UIImage(named: "ProfileGray")!
        profileImageView.image = profileImage
        
        cameraImage = UIImage(named: "Camera")!
        cameraImageView.image = cameraImage
        
        userNickNameTextFiled.font = .bodyM1
        userNickNameTextFiled.textAlignment = .left
        userNickNameTextFiled.textColor = .black
        userNickNameTextFiled.clearButtonMode = .whileEditing
        userNickNameTextFiled.attributedPlaceholder = NSAttributedString(string: userNickName, attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        userNickNameTextFiled.autocorrectionType = .no
        userNickNameTextFiled.spellCheckingType = .no
        userNickNameTextFiled.autocapitalizationType = .none
        userNickNameTextFiled.returnKeyType = .done
        userNickNameTextFiled.resignFirstResponder()

        underlineView.backgroundColor = .gray2
        
        var checkDupleAttr = AttributedString.init("중복검사")
        checkDupleAttr.font = .bodyM3
        checkDupleAttr.foregroundColor = .gray6
        checkDupleBtnConfig.attributedTitle = checkDupleAttr
        
        checkDuplicateButton.configuration = checkDupleBtnConfig
        checkDuplicateButton.contentHorizontalAlignment = .center
        checkDuplicateButton.backgroundColor = .gray1
        checkDuplicateButton.makeRound(radius: 4)
        checkDuplicateButton.isHidden = true
        
        countLabel.text = "\(textCount)/\(maximumCount)"
        countLabel.font = .bodyB3
        countLabel.textAlignment = .right
        countLabel.textColor = .black
        countLabel.isHidden = true
        countLabel.partiallyChanged(targetString: "/\(maximumCount)", font: .bodyM3, color: .gray5)
        
        var doneAttr = AttributedString.init("수정 완료")
        doneAttr.font = .bodyM2
        doneAttr.foregroundColor = .gray3
        doneBtnConfig.attributedTitle = doneAttr
        
        doneButton.configuration = doneBtnConfig
        doneButton.contentHorizontalAlignment = .center
        doneButton.backgroundColor = .gray1
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
}
