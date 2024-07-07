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

class AddFriendsToPlaceViewController: UIViewController {
    // MARK: - UI Components
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
        $0.separatorStyle = .none
    }
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    // MARK: - Properties
    private let viewModel = AddFriendsToPlaceViewModel()
    private let disposeBag = DisposeBag()
    private var collectionViewHeightConstraint: Constraint?
    
    private let selectFriendRelay = PublishRelay<String>()
    private let deselectFriendRelay = PublishRelay<String>()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        setupUI()
        bindTableView()
        bindCollectionView()
        bindSelection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    // MARK: - Custom Methods
    private func setupUI() {
        self.view.backgroundColor = .white
        
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(doneButton)
    }
    
    private func createViewModelInput() -> AddFriendsToPlaceViewModel.Input {
        return AddFriendsToPlaceViewModel.Input(
            selectFriend: selectFriendRelay,
            deselectFriend: deselectFriendRelay
        )
    }
    
    private func bindTableView() {
        tableView.register(AddFriendsTableViewCell.self, forCellReuseIdentifier: AddFriendsTableViewCell.identifier)
        
        let output = viewModel.transform(input: createViewModelInput())
        
        output.friends
            .bind(to: tableView.rx.items(cellIdentifier: AddFriendsTableViewCell.identifier, cellType: AddFriendsTableViewCell.self)) { row, friend, cell in
                cell.nameLabel.text = friend
                
                output.selectedFriends
                    .map { $0.contains(friend) }
                    .bind(to: cell.checkImage.rx.isSelected)
                    .disposed(by: cell.disposeBag)
                
                cell.checkImage.rx.tap
                    .take(until: cell.rx.methodInvoked(#selector(UITableViewCell.prepareForReuse)))
                    .bind { [weak self] in
                        guard let self = self else { return }
                        if output.selectedFriends.value.contains(friend) {
                            self.deselectFriendRelay.accept(friend)
                        } else {
                            self.selectFriendRelay.accept(friend)
                        }
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindCollectionView() {
        collectionView.register(SelectedFriendsCollectionViewCell.self, forCellWithReuseIdentifier: SelectedFriendsCollectionViewCell.identifier)
        
        let output = viewModel.transform(input: createViewModelInput())
        
        output.selectedFriends
            .bind(to: collectionView.rx.items(cellIdentifier: SelectedFriendsCollectionViewCell.identifier, cellType: SelectedFriendsCollectionViewCell.self)) { row, friend, cell in
                cell.configure(with: friend)
                cell.deleteButton.rx.tap
                    .take(until: cell.rx.methodInvoked(#selector(UICollectionViewCell.prepareForReuse)))
                    .bind { [weak self] in
                        self?.deselectFriendRelay.accept(friend)
                    }
                    .disposed(by: cell.disposeBag)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindSelection() {
        let output = viewModel.transform(input: createViewModelInput())
        
        output.selectedFriends
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] selected in
                guard let self = self else { return }
                let newHeight: CGFloat = selected.isEmpty ? 0 : 80
                self.collectionViewHeightConstraint?.update(offset: newHeight)
                
                if self.isViewLoaded && (self.view.window != nil) {
                    UIView.animate(withDuration: 0.3) {
                        self.view.layoutIfNeeded()
                    }
                } else {
                    self.view.layoutIfNeeded()
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc private func skipAction() {
        let myPlaceViewController = MyPlaceViewController()
        navigationController?.pushViewController(myPlaceViewController, animated: true)
    }
}

extension AddFriendsToPlaceViewController {
    private func setNavigationBar() {
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
    
    private func setConstraints() {
        [collectionView, magnifierImageView, textField, underlineView, cancelButton, doneButton, tableView, stackView].forEach {
            view.addSubview($0)
        }
        
        collectionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            collectionViewHeightConstraint = make.height.equalTo(0).constraint
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
