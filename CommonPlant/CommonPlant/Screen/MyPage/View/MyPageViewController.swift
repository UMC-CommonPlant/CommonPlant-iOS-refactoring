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
import Then

final class MyPageViewController: UIViewController {
    // MARK: Properties
    private let viewModel = MyPageViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let backgroundView = UIView()
    private let baseView = UIImageView().then {
        $0.image = UIImage(named: "ProfileBackground")!
    }
    private let userProfileView = UIImageView().then {
        $0.image = UIImage(named: "ProfileGreen")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = 47.5
    }
    private let settingButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Setting")
        $0.configuration = config
    }
    private let userInfoView = UIView()
    private let userNameLabel = UILabel().then {
        $0.text = "커먼플랜트"
        $0.font = .head4
        $0.textAlignment = .center
        $0.textColor = .black
    }
    private let userEmailLabel = UILabel().then {
        $0.text = "common123@gmail.com"
        $0.font = .captionM1
        $0.textAlignment = .center
        $0.textColor = .gray5
    }
    private let editButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Edit")
        $0.configuration = config
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setNavigationBar()
        setHierarchy()
        setConstraints()
        setAction()
    }
    
    // MARK: Custom Method
    func setNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        backBarButtonItem.tintColor = .gray6
        navigationItem.backBarButtonItem = backBarButtonItem
        let rightBarItem = UIBarButtonItem(customView: settingButton)
        navigationItem.rightBarButtonItem = rightBarItem
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
    
    func setConstraints() {
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
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
