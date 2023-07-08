//
//  SettingView.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit
import SnapKit

class SettingView: UIView {
    // MARK: Properties
    
    // MARK: UI Components
    var navigationBarView = UIView()
    var settingTitleLabel = UILabel()
    var alarmView = UIView()
    var alarmTitleLabel = UILabel()
    var alarmSettingLabel = UILabel()
    var alarmGuideLabel = UILabel()
    var alarmToggleSwitch = UISwitch()
    var divideView = UIView()
    var accountView = UIView()
    var accountTitleLabel = UILabel()
    var logoutButton = UIButton()
    var withdrawalButton = UIButton()
    var backButton = UIButton()
    
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
        
        var logoutBtnConfig = UIButton.Configuration.plain()
        var withDrawalBtnConfig = UIButton.Configuration.plain()
        var backBtnConfig = UIButton.Configuration.plain()
        
        backBtnConfig.image = UIImage(named: "Back")
        backButton.configuration = backBtnConfig
        
        settingTitleLabel.text = "설정"
        settingTitleLabel.font = .bodyB1
        settingTitleLabel.textAlignment = .center
        settingTitleLabel.textColor = .black
        
        alarmTitleLabel.text = "알람설정"
        alarmTitleLabel.font = .bodyB1
        alarmTitleLabel.textAlignment = .left
        alarmTitleLabel.textColor = .black
        
        alarmSettingLabel.text = "알림 설정"
        alarmSettingLabel.font = .bodyM2
        alarmSettingLabel.textAlignment = .left
        alarmSettingLabel.textColor = .gray6
        
        alarmGuideLabel.text = "물주기 및 식물의 상태를 알려드려요"
        alarmGuideLabel.font = .captionB2
        alarmGuideLabel.textAlignment = .left
        alarmGuideLabel.textColor = .seaGreenDark3
        
        alarmToggleSwitch.setOn(true, animated: true)
        alarmToggleSwitch.onTintColor = .seaGreenDark1
        alarmToggleSwitch.thumbTintColor = .white
        alarmToggleSwitch.tintColor = .gray3
        alarmToggleSwitch.isOn = false
        alarmToggleSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        divideView.backgroundColor = .gray2
        
        accountTitleLabel.text = "계정"
        accountTitleLabel.font = .bodyB1
        accountTitleLabel.textAlignment = .left
        accountTitleLabel.textColor = .black
        
        var logoutAttr = AttributedString.init("로그아웃")
        logoutAttr.font = .bodyM2
        logoutAttr.foregroundColor = .gray6
        logoutBtnConfig.attributedTitle = logoutAttr
        logoutBtnConfig.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 20)
        logoutButton.configuration = logoutBtnConfig
        logoutButton.contentHorizontalAlignment = .left

        var withdrawalAttr = AttributedString.init("회원탈퇴")
        withdrawalAttr.font = .bodyM2
        withdrawalAttr.foregroundColor = .gray6
        withDrawalBtnConfig.attributedTitle = withdrawalAttr
        withDrawalBtnConfig.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 20)
        withdrawalButton.configuration = withDrawalBtnConfig
        withdrawalButton.contentHorizontalAlignment = .left
    }
    
    func setHierarchy() {
        
    }
    
    func setLayout() {
        
    }
}
