//
//  SearchResultViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/08/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class SearchResultViewController: UIViewController {
    // MARK: - Properties
    var viewModel = SearchResultViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    let searchResultTableView = UITableView()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        setTableView()
    }
    
    // MARK: - Custom Method
    private func setTableView() {
        searchResultTableView.estimatedRowHeight = 92
        searchResultTableView.separatorStyle = .none
        searchResultTableView.register(SearchResultTableViewCell.self, forCellReuseIdentifier: "SearchResultTableViewCell")
        
        viewModel.searchResultObservable
            .bind(to: searchResultTableView.rx.items(cellIdentifier: SearchResultTableViewCell.identifier, cellType: SearchResultTableViewCell.self)) { _, element, cell in
                cell.setAttributes(with: element)
            }
            .disposed(by: disposeBag)
    }

    private func setUI() {
        self.view.addSubview(searchResultTableView)
        
        searchResultTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: - Search Controller
extension SearchResultViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            viewModel.searchPlants(searchText)
        }
    }
}
