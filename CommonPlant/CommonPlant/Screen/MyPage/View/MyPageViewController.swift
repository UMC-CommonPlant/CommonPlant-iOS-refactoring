//
//  MyPageViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/07.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class MyPageViewController: UIViewController {
    // MARK: Properties
    let viewModel = MyPageViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    let backgroundView = UIView()
    let baseView = UIImageView()
    var baseImage = UIImage(named: "ProfileBackground")!
    let userProfileView = UIImageView()
    var settingButton = UIButton()
    let userInfoView = UIView()
    var userNameLabel = UILabel()
    var userEmailLabel = UILabel()
    let editButton = UIButton()
    
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
        
        var settingBtnConfig = UIButton.Configuration.plain()
        var editBtnConfig = UIButton.Configuration.plain()
        
        settingBtnConfig.image = UIImage(named: "Setting")
        settingButton.configuration = settingBtnConfig
        
        editBtnConfig.image = UIImage(named: "Edit")
        editButton.configuration = editBtnConfig
        
        baseView.image = baseImage
        userProfileView.image = viewModel.infoProfileRelay.value!
        
        viewModel.userSubject.subscribe (onNext: { [weak self] userInfo in
            guard let self = self else { return }
            
            userNameLabel.text = userInfo.nickName
            userEmailLabel.text = userInfo.email
        }).disposed(by: disposeBag)

        userNameLabel.font = .head4
        userNameLabel.textAlignment = .center
        userNameLabel.textColor = .black
        
        userEmailLabel.font = .captionM1
        userEmailLabel.textAlignment = .center
        userEmailLabel.textColor = .gray5
    }
    
    func setHierarchy() {
        view.addSubview(backgroundView)
        view.addSubview(userInfoView)
        
        backgroundView.addSubview(baseView)
        backgroundView.addSubview(userProfileView)
        backgroundView.addSubview(settingButton)
        
        userInfoView.addSubview(userNameLabel)
        userInfoView.addSubview(userEmailLabel)
        userInfoView.addSubview(editButton)
    }
    
    func setLayout() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(201)
        }
        
        baseView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        userProfileView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(85)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(95)
        }
        
        settingButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
            make.width.height.equalTo(56)
        }
        
        userInfoView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }
        
        userEmailLabel.snp.makeConstraints { make in
            make.top.equalTo(userNameLabel.snp.bottom)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        editButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().offset(-38.5)
            make.width.height.equalTo(56)
        }
    }
    
    func setAction() {
        settingButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.showSettingView(self)
        }).disposed(by: disposeBag)
        
        
        editButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.showEditView(self)
        }).disposed(by: disposeBag)
    }
}
