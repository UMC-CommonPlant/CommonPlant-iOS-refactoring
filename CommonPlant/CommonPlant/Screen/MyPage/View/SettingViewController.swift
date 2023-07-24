//
//  SettingViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit
import SnapKit
import RxSwift

class SettingViewController: UIViewController {
    // MARK: Properties
    let viewModel = SettingViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    var navigationBarView = UIView()
    var settingTitleLabel = UILabel()
    var alarmView = UIView()
    var alarmTitleLabel = CommonLabel()
    var alarmSettingLabel = UILabel()
    var alarmGuideLabel = UILabel()
    var alarmToggleSwitch = UISwitch()
    var divideView = UIView()
    var accountView = UIView()
    var accountTitleLabel = CommonLabel()
    var logoutButton = UIButton()
    var withdrawalButton = UIButton()
    var backButton = UIButton()
    var backgroundView = UIView()
    var logoutView = UIView()
    var logoutTitleLabel = UILabel()
    var logoutMessageLabel = UILabel()
    var buttonView = UIView()
    var okButton = UIButton()
    var cancleButton = UIButton()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
        setAction()
    }
    
    // MARK: Custom Method
    func setUI() {
        view.backgroundColor = .white
        
        var logoutBtnConfig = UIButton.Configuration.plain()
        var withDrawalBtnConfig = UIButton.Configuration.plain()
        var backBtnConfig = UIButton.Configuration.plain()
        var okBtnConfig = UIButton.Configuration.filled()
        var cancleBtnConfig = UIButton.Configuration.filled()
        
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
        alarmTitleLabel.padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        
        alarmSettingLabel.text = "알림 설정"
        alarmSettingLabel.font = .bodyM2
        alarmSettingLabel.textAlignment = .left
        alarmSettingLabel.textColor = .gray6
        
        alarmGuideLabel.text = "물주기 및 식물의 상태를 알려드려요"
        alarmGuideLabel.font = .captionB2
        alarmGuideLabel.textAlignment = .left
        alarmGuideLabel.textColor = .seaGreenDark3
        
        viewModel.isActiveNotification.subscribe(onNext: { [weak self] isOn in
            self?.alarmToggleSwitch.setOn(isOn, animated: true)
        })
        .disposed(by: disposeBag)
        alarmToggleSwitch.onTintColor = .seaGreenDark1
        alarmToggleSwitch.tintColor = .gray3
        alarmToggleSwitch.thumbTintColor = .white
        alarmToggleSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        divideView.backgroundColor = .gray1
        
        accountTitleLabel.text = "계정"
        accountTitleLabel.font = .bodyB1
        accountTitleLabel.textAlignment = .left
        accountTitleLabel.textColor = .black
        accountTitleLabel.padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        
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
        
        backgroundView.backgroundColor = .black
        backgroundView.layer.opacity = 0.7
        backgroundView.isHidden = true
        
        logoutView.backgroundColor = .white
        logoutView.makeRound(radius: 14)
        logoutView.isHidden = true
        
        logoutTitleLabel.text = "로그아웃"
        logoutTitleLabel.font = .bodyB2
        logoutTitleLabel.textColor = .black
        logoutTitleLabel.textAlignment = .center
        
        logoutMessageLabel.text = "로그아웃 하시겠나요?"
        logoutMessageLabel.font = .bodyM3
        logoutMessageLabel.textColor = .gray6
        logoutMessageLabel.textAlignment = .center
        
        buttonView.backgroundColor = .gray2
        
        var okAttr = AttributedString.init("확인")
        okAttr.font = .bodyB2
        okBtnConfig.attributedTitle = okAttr
        okBtnConfig.baseBackgroundColor = .white
        okBtnConfig.baseForegroundColor = .seaGreenDark3
        okBtnConfig.background.cornerRadius = 0
        okButton.configuration = okBtnConfig
        okButton.contentHorizontalAlignment = .center
        
        var cancleAttr = AttributedString.init("취소")
        cancleAttr.font = .bodyM2
        cancleBtnConfig.attributedTitle = cancleAttr
        cancleBtnConfig.baseBackgroundColor = .white
        cancleBtnConfig.baseForegroundColor = .gray5
        cancleBtnConfig.background.cornerRadius = 0
        cancleButton.configuration = cancleBtnConfig
        cancleButton.contentHorizontalAlignment = .center
    }
    
    func setHierarchy() {
        view.addSubview(navigationBarView)
        view.addSubview(alarmView)
        view.addSubview(accountView)
        view.addSubview(divideView)
        view.addSubview(backgroundView)
        
        navigationBarView.addSubview(settingTitleLabel)
        navigationBarView.addSubview(backButton)
        
        alarmView.addSubview(alarmTitleLabel)
        alarmView.addSubview(alarmSettingLabel)
        alarmView.addSubview(alarmGuideLabel)
        alarmView.addSubview(alarmToggleSwitch)
        
        accountView.addSubview(accountTitleLabel)
        accountView.addSubview(logoutButton)
        accountView.addSubview(withdrawalButton)
        
        view.addSubview(logoutView)
        
        logoutView.addSubview(logoutTitleLabel)
        logoutView.addSubview(logoutMessageLabel)
        logoutView.addSubview(buttonView)
        
        buttonView.addSubview(okButton)
        buttonView.addSubview(cancleButton)
    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(23)
            make.trailing.equalToSuperview().offset(-36)
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
        
        backgroundView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(self.view)
        }
        
        logoutView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(52.5)
            make.trailing.equalToSuperview().offset(-52.5)
            make.height.equalTo(148)
        }
        
        logoutTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(33)
        }
        
        logoutMessageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(logoutTitleLabel.snp.bottom).offset(5)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(104)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo((view.frame.width - 105)/2 - 0.25)
            make.height.equalTo(43.5)
        }
        
        okButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo((view.frame.width - 105)/2 - 0.25)
            make.height.equalTo(43.5)
        }
    }
    
    func setAction() {
        withdrawalButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.showWithdrwalView(self)
        }).disposed(by: disposeBag)
        
        logoutButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            backgroundView.isHidden = false
            logoutView.isHidden = false
        }).disposed(by: disposeBag)
        
        okButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            // 로그아웃 로직
        }).disposed(by: disposeBag)
        
        cancleButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            backgroundView.isHidden = true
            logoutView.isHidden = true
        }).disposed(by: disposeBag)
        
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.dissmissView(self)
        }).disposed(by: disposeBag)
    }
}
