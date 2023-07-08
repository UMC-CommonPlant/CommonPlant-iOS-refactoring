//
//  MyPageView.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/07.
//

import UIKit
import SnapKit

class MyPageView: UIView {
    // MARK: Properties
    
    // MARK: UI Components
    let backgroundView = UIView()
    let baseView = UIImageView()
    var baseImage = UIImage(named: "ProfileBackground")!
    let userProfileView = UIImageView()
    var userProfileImage = UIImage(named: "ProfileGreen")
    var settingButton = UIButton()
    
    let userInfoView = UIView()
    lazy var userNameLabel = UILabel()
    var userEmailLabel = UILabel()
    let editButton = UIButton()
    
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
        
        var settingBtnConfig = UIButton.Configuration.plain()
        var editBtnConfig = UIButton.Configuration.plain()
        
        settingBtnConfig.image = UIImage(named: "Setting")
        settingButton.configuration = settingBtnConfig
        
        editBtnConfig.image = UIImage(named: "Edit")
        editButton.configuration = editBtnConfig
        
        baseView.image = baseImage
        userProfileView.image = userProfileImage
        
        userNameLabel.text = "커먼플랜트"
        userNameLabel.font = .head4
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .black
        
        userEmailLabel.text = "alwaysweave@gmail.com"
        userEmailLabel.font = .captionM1
        userEmailLabel.textAlignment = .center
        userEmailLabel.textColor = .gray5
    }
    
    func setHierarchy() {
        
    }
    
    func setLayout() {
        
    }
}
