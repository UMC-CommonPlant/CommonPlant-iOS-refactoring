//
//  WithdrwalViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

final class WithdrwalViewController: UIViewController {
    // MARK: Properties
    private let viewModel = WithdrwalViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let backgroundView = UIView().then {
        $0.backgroundColor = .seaGreen
    }
    private let warningTitleLabel = UILabel().then {
        $0.text = "커먼플랜트님, 잠시만요!"
        $0.font = .head5
        $0.textAlignment = .center
        $0.textColor = .black
    }
    private let leaveView = UIImageView().then {
        $0.image = UIImage(named: "LeaveLogo")!
    }
    private let guideLabel = UILabel().then {
        $0.text = """
        
        • 회원 탈퇴 시 현재 계정으로 작성한 게시글, 댓글 등을 수정할 수 없습니다.
        
        • 탈퇴 후에는 계정을 다시 살리거나 데이터를 복구할 수 없습니다.
        
        • 본 계정으로 다시는 로그인 할 수 없습니다.
        """
        $0.font = .bodyM3
        $0.textAlignment = .left
        $0.textColor = .gray6
        $0.numberOfLines = 0
        $0.lineBreakMode = .byCharWrapping
    }
    private let bottomView = UIView()
    private let checkButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "UnselectedGray")
        $0.configuration = config
    }
    private let confirmLabel = UILabel().then {
        $0.text = "유의사항을 모두 확인했습니다."
        $0.font = .bodyM2
        $0.textAlignment = .left
        $0.textColor = .black
    }
    private let deleteButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("계정 삭제하기")
        attr.font = .bodyM2
        attr.foregroundColor = .gray3
        config.attributedTitle = attr
        $0.configuration = config
        $0.contentHorizontalAlignment = .center
        $0.backgroundColor = .gray1
        $0.makeRound(radius: 8)
    }
    private let selectedGray = UIImage(named: "SelectedGray")
    private let unSelectedGray = UIImage(named: "UnselectedGray")
    
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
        navigationItem.title = "회원탈퇴"
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .gray6
        navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    func setHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(backgroundView)
        contentView.addSubview(bottomView)
        
        bottomView.addSubview(checkButton)
        bottomView.addSubview(confirmLabel)
        bottomView.addSubview(deleteButton)
        
        backgroundView.addSubview(warningTitleLabel)
        backgroundView.addSubview(leaveView)
        backgroundView.addSubview(guideLabel)
    }
    
    func setLayout() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
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
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        bottomView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(backgroundView.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        checkButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        confirmLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(17)
            make.leading.equalTo(checkButton.snp.trailing).offset(12)
            make.height.equalTo(22)
        }
        
        deleteButton.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(confirmLabel.snp.bottom).offset(33)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().offset(-32)
            make.height.equalTo(48)
        }
    }
    
    func setAction() {
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
