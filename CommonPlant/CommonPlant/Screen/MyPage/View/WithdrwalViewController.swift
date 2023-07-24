//
//  WithdrwalViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit
import RxSwift
import RxCocoa

class WithdrwalViewController: UIViewController {
    // MARK: Properties
    var viewModel = WithdrwalViewModel()
    var disposeBag = DisposeBag()
    
    // MARK: UI Components
    var scrollView = UIScrollView()
    var contentView = UIView()
    var navigationBarView = UIView()
    var withdrawalTitleLabel = UILabel()
    var backButton = UIButton()
    var backgroundView = UIView()
    var warningTitleLabel = UILabel()
    var leaveView = UIImageView()
    var leaveImage = UIImage()
    var guideLabel = UILabel()
    var bottomView = UIView()
    var checkButton = UIButton()
    var confirmLabel = UILabel()
    var deleteButton = UIButton()
    var selectedGray = UIImage(named: "SelectedGray")
    var unSelectedGray = UIImage(named: "UnselectedGray")
    
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
        var checkBtnConfig = UIButton.Configuration.plain()
        var deleteBtnConfig = UIButton.Configuration.plain()
        
        backBtnConfig.image = UIImage(named: "Back")
        backButton.configuration = backBtnConfig
        
        withdrawalTitleLabel.text = "회원탈퇴"
        withdrawalTitleLabel.font = .bodyB1
        withdrawalTitleLabel.textAlignment = .center
        withdrawalTitleLabel.textColor = .gray6
        
        backgroundView.backgroundColor = .seaGreen
        
        MyPageViewModel.shared.userSubject.subscribe(onNext: { [weak self] userInfo in
            self?.warningTitleLabel.text = "\(userInfo.nickName)님 잠시만요!"
        }).disposed(by: disposeBag)
        warningTitleLabel.font = .head5
        warningTitleLabel.textAlignment = .center
        warningTitleLabel.textColor = .black
        
        leaveImage = UIImage(named: "LeaveLogo")!
        
        leaveView.image = leaveImage
        
        guideLabel.text = """
        
        • 회원 탈퇴 시 현재 계정으로 작성한 게시글, 댓글 등을 수정할 수 없습니다.
        
        • 탈퇴 후에는 계정을 다시 살리거나 데이터를 복구할 수 없습니다.
        
        • 본 계정으로 다시는 로그인 할 수 없습니다.
        """
        guideLabel.font = .bodyM3
        guideLabel.textAlignment = .left
        guideLabel.textColor = .gray6
        guideLabel.numberOfLines = 0
        guideLabel.lineBreakMode = .byCharWrapping
        
        checkBtnConfig.image = UIImage(named: "UnselectedGray")
        checkButton.configuration = checkBtnConfig
        
        confirmLabel.text = "유의사항을 모두 확인했습니다."
        confirmLabel.font = .bodyM2
        confirmLabel.textAlignment = .left
        confirmLabel.textColor = .black
        
        var deleteAttr = AttributedString.init("계정 삭제하기")
        deleteAttr.font = .bodyM2
        deleteAttr.foregroundColor = .gray3
        deleteButton.contentHorizontalAlignment = .center
        deleteButton.makeRound(radius: 8)
        
        viewModel.isOnCheckBtn.map { isOn -> (UIColor, UIColor, UIImage, Bool) in
            return isOn ? (.seaGreenDark1!, .white, self.selectedGray!, true) : (.gray1!, .gray3!, self.unSelectedGray!, false)
        }
        .subscribe(onNext: { [weak self] backgroundColor, titleColor, image, isEnable in
            guard let self = self else { return }
            deleteAttr.foregroundColor = titleColor
            deleteBtnConfig.attributedTitle = deleteAttr
            deleteButton.configuration = deleteBtnConfig
            deleteButton.backgroundColor = backgroundColor
            deleteButton.isEnabled = isEnable
            
            checkButton.configuration?.image = image
        })
        .disposed(by: disposeBag)
    }
    
    func setHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(navigationBarView)
        contentView.addSubview(backgroundView)
        contentView.addSubview(bottomView)
        
        bottomView.addSubview(checkButton)
        bottomView.addSubview(confirmLabel)
        bottomView.addSubview(deleteButton)
        
        navigationBarView.addSubview(withdrawalTitleLabel)
        navigationBarView.addSubview(backButton)
        
        backgroundView.addSubview(warningTitleLabel)
        backgroundView.addSubview(leaveView)
        backgroundView.addSubview(guideLabel)
    }
    
    func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(scrollView)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        navigationBarView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(56)
        }
        
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.height.equalTo(56)
        }
        
        withdrawalTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(19)
            make.centerX.equalToSuperview()
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(navigationBarView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(502)
        }
        
        warningTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.centerX.equalToSuperview()
        }
        
        leaveView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(92)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(148)
        }
        
        guideLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(314)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(backgroundView.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(24)
        }
        
        confirmLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalTo(checkButton.snp.trailing).offset(12)
            make.height.equalTo(22)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(confirmLabel.snp.bottom).offset(33)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-32)
            make.height.equalTo(48)
        }
    }
    
    func setAction() {
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            viewModel.dissmissView(self)
        }).disposed(by: disposeBag)
        
        checkButton.rx.tap.subscribe(onNext: { [weak self] button in
            guard let self = self else { return }

            viewModel.isOnCheckBtn.accept(!viewModel.isOnCheckBtn.value)
        }).disposed(by: disposeBag)
       
        deleteButton.rx.tap.map { value -> UIColor in
            return .seaGreenDark3!
        }.subscribe(onNext: { [weak self] backgroundColor in
            guard let self = self else { return }
            deleteButton.backgroundColor = backgroundColor
            // 탈퇴 로직
        }).disposed(by: disposeBag)
    }
}
