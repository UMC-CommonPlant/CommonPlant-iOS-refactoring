//
//  WithdrwalViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit

class WithdrwalViewController: UIViewController {
    // MARK: Properties
    var userNickName: String = "커먼"
    var isOnClickCheckBtn: Bool = false
    
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
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setHierarchy()
        setLayout()
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
        
        warningTitleLabel.text = "\(userNickName)님 잠시만요!"
        warningTitleLabel.font = .head5
        warningTitleLabel.textAlignment = .center
        warningTitleLabel.textColor = .black
        
        leaveImage = UIImage(named: "LeaveLogo")!
        
        leaveView.image = leaveImage
        
        guideLabel.text = """
        ● 회원 탈퇴 시 현재 계정으로 작성한 게시글, 댓글 등을 수정할 수 없습니다.
        
        ● 탈퇴 후에는 계정을 다시 살리거나 데이터를 복구할 수 없습니다.
        
        ● 본 계정으로 다시는 로그인 할 수 없습니다.
        """
        guideLabel.font = .captionM1
        guideLabel.textAlignment = .left
        guideLabel.textColor = .gray6
        guideLabel.numberOfLines = 0
        guideLabel.lineBreakMode = .byCharWrapping
        
        checkButton.configurationUpdateHandler = { button in
            if self.isOnClickCheckBtn {
                button.configuration?.image = UIImage(named: "SelectedGray")
                self.isOnClickCheckBtn = false
            } else {
                button.configuration?.image = UIImage(named: "UnselectedGray")
                self.isOnClickCheckBtn = true
            }
        }
        checkBtnConfig.image = UIImage(named: "UnselectedGray")
        checkButton.configuration = checkBtnConfig
        
        confirmLabel.text = "유의사항을 모두 확인했습니다."
        confirmLabel.font = .bodyM2
        confirmLabel.textAlignment = .left
        confirmLabel.textColor = .black
        
        var deleteAttr = AttributedString.init("계정 삭제하기")
        deleteAttr.font = .bodyM2
        deleteAttr.foregroundColor = .gray3
        deleteBtnConfig.attributedTitle = deleteAttr
        
        deleteButton.configuration = deleteBtnConfig
        deleteButton.contentHorizontalAlignment = .center
        deleteButton.backgroundColor = .gray1
        deleteButton.makeRound(radius: 8)
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
}
