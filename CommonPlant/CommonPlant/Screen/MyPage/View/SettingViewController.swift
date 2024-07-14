//
//  SettingViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit
import SnapKit
import RxSwift

final class SettingViewController: UIViewController {
    // MARK: Properties
    let viewModel = SettingViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let alarmView = UIView()
    private let alarmTitleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "알람설정"
        label.font = .bodyB1
        label.textAlignment = .left
        label.textColor = .black
        label.padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        return label
    }()
    private let alarmSettingLabel: UILabel = {
        let label = UILabel()
        label.text = "알림 설정"
        label.font = .bodyM2
        label.textAlignment = .left
        label.textColor = .gray6
        return label
    }()
    private let alarmGuideLabel: UILabel = {
        let label = UILabel()
        label.text = "물주기 및 식물의 상태를 알려드려요"
        label.font = .captionB2
        label.textAlignment = .left
        label.textColor = .seaGreenDark3
        return label
    }()
    private let alarmToggleSwitch: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = .seaGreenDark1
        toggle.tintColor = .gray3
        toggle.thumbTintColor = .white
        toggle.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        return toggle
    }()
    private let divideView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    private let accountView = UIView()
    private let accountTitleLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.text = "계정"
        label.font = .bodyB1
        label.textAlignment = .left
        label.textColor = .black
        label.padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
        return label
    }()
    private let logoutButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("로그아웃")
        attr.font = .bodyM2
        attr.foregroundColor = .gray6
        config.attributedTitle = attr
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 20)
        button.configuration = config
        button.contentHorizontalAlignment = .left
        return button
    }()
    private let logoutAlertView: CommonAlertView = {
        let view = CommonAlertView()
        view.setTitle("로그아웃")
        view.setMessage("로그아웃을 하시겠나요?")
        view.setActionButton(title: "확인")
        view.isHidden = true
        return view
    }()
    private let withdrawalButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("회원탈퇴")
        attr.font = .bodyM2
        attr.foregroundColor = .gray6
        config.attributedTitle = attr
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 20)
        button.configuration = config
        button.contentHorizontalAlignment = .left
        return button
    }()
    private let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.opacity = 0.7
        view.isHidden = true
        return view
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar()
        setHierarchy()
        setLayout()
        setAction()
    }
    
    // MARK: Custom Method
    func setNavigationBar() {
        navigationItem.title = "설정"
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .gray6
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setHierarchy() {
        view.addSubview(alarmView)
        view.addSubview(accountView)
        view.addSubview(divideView)
        view.addSubview(backgroundView)
        view.addSubview(logoutAlertView)
        
        alarmView.addSubview(alarmTitleLabel)
        alarmView.addSubview(alarmSettingLabel)
        alarmView.addSubview(alarmGuideLabel)
        alarmView.addSubview(alarmToggleSwitch)
        
        accountView.addSubview(accountTitleLabel)
        accountView.addSubview(logoutButton)
        accountView.addSubview(withdrawalButton)
    }
    
    func setLayout() {
        alarmView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
        
        logoutAlertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(52.5)
            make.trailing.equalToSuperview().offset(-52.5)
            make.height.equalTo(148)
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
            logoutAlertView.isHidden = false
        }).disposed(by: disposeBag)
        
        logoutAlertView.actionButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            // 로그아웃 로직
        }).disposed(by: disposeBag)
        
        logoutAlertView.cancleButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            backgroundView.isHidden = true
            logoutAlertView.isHidden = true
        }).disposed(by: disposeBag)
    }
}
