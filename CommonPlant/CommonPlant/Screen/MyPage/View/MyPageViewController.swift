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

final class MyPageViewController: UIViewController {
    // MARK: Properties
    private let viewModel = MyPageViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let backgroundView = UIView()
    private let baseView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ProfileBackground")!
        return view
    }()
    private let userProfileView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ProfileGreen")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 47.5
        return view
    }()
    private let settingButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Setting")
        button.configuration = config
        return button
    }()
    private let userInfoView = UIView()
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "커먼플랜트"
        label.font = .head4
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private let userEmailLabel: UILabel = {
        let label = UILabel()
        label.text = "common123@gmail.com"
        label.font = .captionM1
        label.textAlignment = .center
        label.textColor = .gray5
        return label
    }()
    private let editButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "Edit")
        button.configuration = config
        return button
    }()
    
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
