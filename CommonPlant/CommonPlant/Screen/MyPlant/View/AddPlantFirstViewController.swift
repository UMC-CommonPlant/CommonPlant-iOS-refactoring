//
//  AddPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 1/18/24.
//

import UIKit
import SnapKit

class AddPlantFirstViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = AddPlantFirstViewModel()
    private lazy var input = AddPlantFirstViewModel.Input(searchBtnDidTap: searchTextField.rx.controlEvent([.editingDidEndOnExit]).withLatestFrom(searchTextField.rx.value.orEmpty), selectedPlant: searchResultTableView.rx.itemSelected.asObservable())
    private lazy var output = viewModel.transform(input: input)
    
    // MARK: - UI Components
    private let searchView: UIView = {
        let view = UIView()
        return view
    }()
    private let magnifierImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Search")
        return view
    }()
    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "식물을 입력해주세요"
        tf.font = .bodyM1
        tf.textColor = .black
        tf.tintColor = .black
        tf.returnKeyType = .search
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray1
        return view
    }()
    private let searchResultTableView: UITableView = {
        let view = UITableView()
        view.separatorStyle = .none
        view.rowHeight = 92
        view.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setNavigationBar()
        setConstraints()
        bind()
    }
    
    func bind() {
        viewModel.searchResultList.bind(to: searchResultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) { (_, result, cell) in
            cell.setAttributes(with: result)
        }.disposed(by: viewModel.disposeBag)
        
        output.transigionNextStep.drive { [ weak self ] result in
            guard let self = self else { return }
            // TODO: 식물 등록(2/2) 화면 전환
            print(result)
            let nextVC = AddPlantSecondViewController(name: result.plantName)
            self.navigationController?.pushViewController(nextVC, animated: true)
        }.disposed(by: viewModel.disposeBag)
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "식물 등록(1/2)"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    private func setConstraints() {
        [searchView, searchResultTableView].forEach {
            view.addSubview($0)
        }
        
        [magnifierImageView, searchTextField, underlineView].forEach {
            searchView.addSubview($0)
        }
        
        searchView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(64)
        }
        
        magnifierImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(20)
            make.width.height.equalTo(24)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(magnifierImageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
        }
        
        underlineView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        searchResultTableView.snp.makeConstraints { make in
            make.top.equalTo(searchView.snp.bottom).offset(8)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}
