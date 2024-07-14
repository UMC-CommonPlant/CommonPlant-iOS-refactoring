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

class WithdrwalViewController: UIViewController {
    // MARK: Properties
    let viewModel = WithdrwalViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreen
        return view
    }()
    let warningTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "커먼플랜트님, 잠시만요!"
        label.font = .head5
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    let leaveView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "LeaveLogo")!
        return view
    }()
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = """
        
        • 회원 탈퇴 시 현재 계정으로 작성한 게시글, 댓글 등을 수정할 수 없습니다.
        
        • 탈퇴 후에는 계정을 다시 살리거나 데이터를 복구할 수 없습니다.
        
        • 본 계정으로 다시는 로그인 할 수 없습니다.
        """
        label.font = .bodyM3
        label.textAlignment = .left
        label.textColor = .gray6
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    let bottomView = UIView()
    let checkButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "UnselectedGray")
        button.configuration = config
        return button
    }()
    let confirmLabel: UILabel = {
        let label = UILabel()
        label.text = "유의사항을 모두 확인했습니다."
        label.font = .bodyM2
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()
    let deleteButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attr = AttributedString.init("계정 삭제하기")
        attr.font = .bodyM2
        attr.foregroundColor = .gray3
        config.attributedTitle = attr
        button.configuration = config
        button.contentHorizontalAlignment = .center
        button.backgroundColor = .gray1
        button.makeRound(radius: 8)
        return button
    }()
    let selectedGray = UIImage(named: "SelectedGray")
    let unSelectedGray = UIImage(named: "UnselectedGray")
    
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
