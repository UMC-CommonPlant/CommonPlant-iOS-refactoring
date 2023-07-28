//
//  PrivacyViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/27.
//

import UIKit
import RxSwift

class PrivacyViewController: UIViewController {
    // MARK: Properties
    var viewModel = PrivacyViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    var navigationBarView = UIView()
    var backButton = UIButton()
    var titleLabel = UILabel()
    var scrollView = UIScrollView()
    var contentView = UIView()
    var contentLabel = UILabel()
    var privacyView = UIView()
    var checkButton = UIButton()
    var agreeLabel = UILabel()
    var doneButton = UIButton()
    
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
        
        var backBtnConfig = UIButton.Configuration.plain()
        var doneBtnConfig = UIButton.Configuration.plain()
        var checkBtnConfig = UIButton.Configuration.plain()
        
        backBtnConfig.image = UIImage(named: "Back")
        backButton.configuration = backBtnConfig
        
        titleLabel.text = "개인정보 이용약관"
        titleLabel.font = .bodyB1
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        
        contentLabel.text = """
        Lorem ipsum dolor sit amet consectetur. Ut scelerisque aliquet nisl facilisi molestie porttitor risus eget. Erat mattis gravida quis consequat. Leo aenean scelerisque at dolor ultrices pellentesque est fermentum aliquam. Eget viverra risus ac sem lacus sed pellentesque nibh. Neque et vel urna tortor et proin. Sollicitudin at tempor pharetra eget. Faucibus ipsum faucibus risus odio aliquam tristique non enim amet. Quam quam ullamcorper semper proin quis sed velit nunc curabitur. Ultrices ullamcorper nisi sed dignissim amet facilisis viverra tempor in. Mollis facilisi euismod sed ligula euismod duis commodo suspendisse. Commodo tellus convallis ac quis. Lorem ipsum dolor sit amet consectetur. Ut scelerisque aliquet nisl facilisi molestie porttitor risus eget. Erat mattis gravida quis consequat. Leo aenean scelerisque at dolor ultrices pellentesque est fermentum aliquam. Eget viverra risus ac sem lacus sed pellentesque nibh. Neque et vel urna tortor et proin. Sollicitudin at tempor pharetra eget. Faucibus ipsum faucibus risus odio aliquam tristique non enim amet. Quam quam ullamcorper semper proin quis sed velit nunc curabitur. Ultrices ullamcorper nisi sed dignissim amet facilisis viverra tempor in. Mollis facilisi euismod sed ligula euismod duis commodo suspendisse. Commodo tellus convallis ac quis.
        """
        contentLabel.font = .bodyM2
        contentLabel.textColor = .black
        contentLabel.lineBreakMode = .byCharWrapping
        contentLabel.numberOfLines = 0
        
        agreeLabel.text = "동의합니다"
        agreeLabel.font = .bodyM2
        agreeLabel.textAlignment = .left
        agreeLabel.textColor = .black
        
        var doneAttr = AttributedString.init("확인")
        doneAttr.font = .bodyM2
        doneButton.contentHorizontalAlignment = .center
        doneButton.makeRound(radius: 8)
        
        viewModel.isAgreePolicy.map { isAgree -> ( UIColor, UIColor, Bool) in
            var buttonConfig: (UIColor, UIColor, Bool)
            
            if isAgree {
                checkBtnConfig.image = UIImage(named: "SelectedGray")
                buttonConfig = (.white, .seaGreenDark1!, true)
            } else {
                checkBtnConfig.image = UIImage(named: "UnselectedGray")
                buttonConfig = (.gray3!, .gray1!, false)
            }
            
            self.checkButton.configuration = checkBtnConfig
            return buttonConfig
        }.subscribe(onNext: { [weak self] foregroundColor, backgroundColor, isEnable in
            guard let self = self else { return }
            
            doneAttr.foregroundColor = foregroundColor
            doneBtnConfig.attributedTitle = doneAttr
            
            doneButton.configuration = doneBtnConfig
            doneButton.backgroundColor = backgroundColor
            doneButton.isEnabled = isEnable
        }).disposed(by: disposeBag)
    }
    
    func setHierarchy() {
        view.addSubview(navigationBarView)
        view.addSubview(scrollView)
        view.addSubview(privacyView)
        view.addSubview(doneButton)
        
        navigationBarView.addSubview(backButton)
        navigationBarView.addSubview(titleLabel)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        privacyView.addSubview(checkButton)
        privacyView.addSubview(agreeLabel)
    }
    
    func setLayout() {
        navigationBarView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(privacyView.snp.top)
        }

        contentView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(scrollView)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        privacyView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(doneButton.snp.top).offset(-16)
            make.height.equalTo(72)
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(32)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalTo(24)
        }

        agreeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(33)
            make.leading.equalTo(checkButton.snp.trailing).offset(12)
            make.bottom.equalToSuperview().offset(-17)
        }
        
        doneButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-43)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.height.equalTo(48)
        }
    }
    
    func setAction() {
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.dissmissView(self)
        }).disposed(by: disposeBag)
        
        checkButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            do {
                if try viewModel.isAgreePolicy.value() {
                    viewModel.isAgreePolicy.onNext(false)
                } else {
                    viewModel.isAgreePolicy.onNext(true)
                }
            } catch {
                print("\(error)")
            }
        }).disposed(by: disposeBag)
        
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            doneButton.backgroundColor = .seaGreenDark3
            SignUpViewModel.shared.isAgreePolicy.onNext(true)
            viewModel.dissmissView(self)
        }).disposed(by: disposeBag)
    }
}
