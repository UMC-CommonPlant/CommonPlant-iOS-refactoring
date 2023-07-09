//
//  EditUserInfoView.swift
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

class EditUserInfoView: UIView {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setHierarchy()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Custom Method
    func setUI() {
        backgroundColor = .white
        
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
        
    }
    
    func setLayout() {
        
    }
}
