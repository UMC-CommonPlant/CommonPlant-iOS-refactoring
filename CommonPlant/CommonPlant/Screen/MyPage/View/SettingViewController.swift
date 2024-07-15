//
//  SettingViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit
import SnapKit
import RxSwift
import Then

final class SettingViewController: UIViewController {
    // MARK: Properties
    let viewModel = SettingViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let alarmView = UIView()
    private let alarmTitleLabel = PaddingLabel().then {
        $0.text = "알람설정"
        $0.font = .bodyB1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
    }
    private let alarmSettingLabel = UILabel().then {
        $0.text = "알림 설정"
        $0.font = .bodyM2
        $0.textAlignment = .left
        $0.textColor = .gray6
    }
    private let alarmGuideLabel = UILabel().then {
        $0.text = "물주기 및 식물의 상태를 알려드려요"
        $0.font = .captionB2
        $0.textAlignment = .left
        $0.textColor = .seaGreenDark3
    }
    private let alarmToggleSwitch = UISwitch().then {
        $0.onTintColor = .seaGreenDark1
        $0.tintColor = .gray3
        $0.thumbTintColor = .white
        $0.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    private let divideView = UIView().then {
        $0.backgroundColor = .gray1
    }
    private let accountView = UIView()
    private let accountTitleLabel = PaddingLabel().then {
        $0.text = "계정"
        $0.font = .bodyB1
        $0.textAlignment = .left
        $0.textColor = .black
        $0.padding = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0)
    }
    private let logoutButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("로그아웃")
        attr.font = .bodyM2
        attr.foregroundColor = .gray6
        config.attributedTitle = attr
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 20)
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }
    private let logoutAlertView = CommonAlertView().then {
        $0.setTitle("로그아웃")
        $0.setMessage("로그아웃을 하시겠나요?")
        $0.setActionButton(title: "확인")
        $0.isHidden = true
    }
    private let withdrawalButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("회원탈퇴")
        attr.font = .bodyM2
        attr.foregroundColor = .gray6
        config.attributedTitle = attr
        config.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 16, bottom: 20, trailing: 20)
        $0.configuration = config
        $0.contentHorizontalAlignment = .left
    }
    private let backgroundView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.opacity = 0.7
        $0.isHidden = true
    }
    
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
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(127)
        }
        
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        alarmSettingLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(25)
            make.leading.equalToSuperview().inset(36)
            make.height.equalTo(24)
        }
        
        alarmToggleSwitch.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(23)
            make.trailing.equalToSuperview().inset(36)
        }
        
        alarmGuideLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmSettingLabel.snp.bottom)
            make.leading.equalToSuperview().inset(36)
        }
        
        divideView.snp.makeConstraints { make in
            make.top.equalTo(alarmView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(8)
        }
        
        accountView.snp.makeConstraints { make in
            make.top.equalTo(divideView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        accountTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(24)
        }
        
        logoutButton.snp.makeConstraints { make in
            make.top.equalTo(accountTitleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(62)
        }
        
        withdrawalButton.snp.makeConstraints { make in
            make.top.equalTo(logoutButton.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(62)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        logoutAlertView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(52.5)
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
