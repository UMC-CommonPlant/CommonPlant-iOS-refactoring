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
        addSubview(navigationBarView)
        addSubview(alarmView)
        addSubview(accountView)
        addSubview(divideView)
        
        navigationBarView.addSubview(settingTitleLabel)
        navigationBarView.addSubview(backButton)
        
        alarmView.addSubview(alarmTitleLabel)
        alarmView.addSubview(alarmSettingLabel)
        alarmView.addSubview(alarmGuideLabel)
        alarmView.addSubview(alarmToggleSwitch)
        
        accountView.addSubview(accountTitleLabel)
        accountView.addSubview(logoutButton)
        accountView.addSubview(withdrawalButton)
    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        settingTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.leading.equalTo(backButton.snp.trailing).offset(8)
            make.centerX.equalToSuperview()
        }
        
        alarmView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(127)
        }
        
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(44)
        }
        
        alarmSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(36)
            make.height.equalTo(24)
        }
        
        alarmToggleSwitch.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(24)
            make.trailing.equalToSuperview().offset(-36)
            //make.width.equalTo(40)
            //make.height.equalTo(24)
        }
        
        alarmGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmSettingLabel.snp.bottom)
            make.leading.equalToSuperview().offset(36)
        }
        
        divideView.snp.makeConstraints { make in
            make.top.equalTo(alarmView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(8)
        }
        
        accountView.snp.makeConstraints { make in
            make.top.equalTo(divideView.snp.bottom).offset(16)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        accountTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(24)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(accountTitleLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(62)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(20)
            make.height.equalTo(62)
        }
    }
}
