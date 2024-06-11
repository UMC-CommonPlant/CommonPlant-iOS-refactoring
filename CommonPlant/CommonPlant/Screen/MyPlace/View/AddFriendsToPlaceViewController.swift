//
//  AddPlaceFriendViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 6/4/24.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

#Preview {
    AddFriendsToPlaceViewController()
}

class AddFriendsToPlaceViewController: UIViewController {
    // MARK: - Properties
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewFlowLayout).then {
        $0.showsHorizontalScrollIndicator = false
    }
    private let collectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 4
        $0.itemSize = CGSize(width: 56, height: 57)
    }
    private let magnifierImageView = UIImageView().then {
        $0.image = UIImage(named: "Search")
    }
    private let textField = UITextField().then {
        $0.placeholder = "닉네임 검색"
        $0.font = .bodyM1
    }
    private let underlineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    private let cancelButton = CommonCTAButton(size: .mid, color: .gray).then {
        $0.setTitle("취소", for: .normal)
    }
    private let doneButton = CommonCTAButton(size: .mid, color: .green).then {
        $0.setTitle("완료", for: .normal)
    }
    private let tableView = UITableView().then {
        $0.backgroundColor = .white
        
    }
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setStackView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    @objc private func skipAction() {
        let myPlaceViewController = MyPlaceViewController()
        navigationController?.pushViewController(myPlaceViewController, animated: true)
    }
}

extension AddFriendsToPlaceViewController {
    private func setNavigationBar() {
        self.view.backgroundColor = .white
        let skipButton = UIBarButtonItem(title: "건너뛰기", style: .plain, target: self, action: #selector(skipAction))
        navigationItem.rightBarButtonItem = skipButton
        self.navigationItem.backButtonTitle = ""
        self.navigationItem.title = "장소에 친구 추가"
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.bodyM4,
            .foregroundColor: UIColor.gray5 ?? .systemGray5
        ]
        skipButton.setTitleTextAttributes(attributes, for: .normal)
        skipButton.setTitleTextAttributes(attributes, for: .highlighted)
    }

    
    private func setStackView() {
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(doneButton)
    }
    
    private func setConstraints() {
        [collectionView, magnifierImageView, textField, underlineView, cancelButton, doneButton, tableView, stackView].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        magnifierImageView.snp.makeConstraints { make in
            make.width.height.equalTo(32)
            make.top.equalTo(collectionView.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.height.equalTo(24)
            make.left.equalTo(magnifierImageView.snp.right).offset(8)
            make.centerY.equalTo(magnifierImageView)
        }
        
        underlineView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.top.equalTo(magnifierImageView.snp.bottom).offset(15)
            make.left.right.equalToSuperview()
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(underlineView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(stackView.snp.top).offset(-16)
        }
        
        stackView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
