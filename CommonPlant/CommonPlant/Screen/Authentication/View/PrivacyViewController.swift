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
    private let viewModel: PrivacyViewModel
    
    lazy var input = PrivacyViewModel.Input(backBtnDidTap: backButton.rx.tap.asObservable(), agreeBtnDidTap: privacyView.rx.tapGesture().map { _ in self.doneButton.isEnabled }.asObservable(), doneBtnDidTap: doneButton.rx.tap.asObservable())
    lazy var output = viewModel.transform(input: input)
    
    // MARK: UI Components
    private let navigationBarView = UIView()
    private let backButton: UIButton = {
        let button = UIButton()
        var btnConfig = UIButton.Configuration.plain()
        
        btnConfig.image = UIImage(named: "Back")
        button.configuration = btnConfig
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 이용약관"
        label.font = .bodyB1
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.text = """
        Lorem ipsum dolor sit amet consectetur. Ut scelerisque aliquet nisl facilisi molestie porttitor risus eget. Erat mattis gravida quis consequat. Leo aenean scelerisque at dolor ultrices pellentesque est fermentum aliquam. Eget viverra risus ac sem lacus sed pellentesque nibh. Neque et vel urna tortor et proin. Sollicitudin at tempor pharetra eget. Faucibus ipsum faucibus risus odio aliquam tristique non enim amet. Quam quam ullamcorper semper proin quis sed velit nunc curabitur. Ultrices ullamcorper nisi sed dignissim amet facilisis viverra tempor in. Mollis facilisi euismod sed ligula euismod duis commodo suspendisse. Commodo tellus convallis ac quis. Lorem ipsum dolor sit amet consectetur. Ut scelerisque aliquet nisl facilisi molestie porttitor risus eget. Erat mattis gravida quis consequat. Leo aenean scelerisque at dolor ultrices pellentesque est fermentum aliquam. Eget viverra risus ac sem lacus sed pellentesque nibh. Neque et vel urna tortor et proin. Sollicitudin at tempor pharetra eget. Faucibus ipsum faucibus risus odio aliquam tristique non enim amet. Quam quam ullamcorper semper proin quis sed velit nunc curabitur. Ultrices ullamcorper nisi sed dignissim amet facilisis viverra tempor in. Mollis facilisi euismod sed ligula euismod duis commodo suspendisse. Commodo tellus convallis ac quis.
        """
        label.font = .bodyM2
        label.textColor = .black
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 0
        return label
    }()
    private let privacyView = UIView()
    private var checkButton: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "UnselectedGray")
        return view
    }()
    private let agreeLabel: UILabel = {
        let label = UILabel()
        label.text = "동의합니다"
        label.font = .bodyM2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    private let doneButton: UIButton = {
        let button = UIButton()
        var btnConfig = UIButton.Configuration.plain()
        var btnAttr = AttributedString.init("확인")
        btnAttr.font = .bodyM2
        btnConfig.attributedTitle = btnAttr
        btnConfig.baseForegroundColor = .gray3
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .gray1
        button.configuration = btnConfig
        button.makeRound(radius: 8)
        button.isEnabled = false
        return button
    }()
    
    init(_ viewModel: AnyObject) {
        self.viewModel = viewModel as! PrivacyViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        bind()
        setConstraints()
    }
    
    // MARK: Custom Method
    func bind() {
        output.dismiss.drive { [weak self] _ in
            guard let self = self else { return }
            
            self.dismiss(animated: true)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.isAgreePolicy.subscribe { [weak self] isAgree in
            guard let self = self else { return }
            
            checkButton.image = isAgree ? UIImage(named: "SelectedGray") : UIImage(named: "UnselectedGray")
            doneButton.configuration?.baseForegroundColor = isAgree ? .white : .gray3
            doneButton.backgroundColor = isAgree ? .seaGreenDark1 : .gray1
            doneButton.isEnabled = isAgree
        }.disposed(by: viewModel.disposeBag)
    }
    
    func setConstraints() {
        [navigationBarView, scrollView, privacyView, doneButton].forEach {
            view.addSubview($0)
        }
        
        [backButton, titleLabel].forEach {
            navigationBarView.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(contentLabel)
        
        [checkButton, agreeLabel].forEach {
            privacyView.addSubview($0)
        }
        
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
}
