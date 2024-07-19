//
//  PlantInfoViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/24.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class PlantInfoViewController: UIViewController {
    // MARK: - Properties
    private let viewModel = PlantInfoViewModel()
    private let disposeBag = DisposeBag()
    private let selectCategorySubject = PublishSubject<CategoryModel>()
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let searchResultController = SearchResultViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultController)
    private let borderLineView = UIView().then {
        $0.backgroundColor = .gray2
    }
    private let plantCategoryLabel = UILabel().then {
        $0.text = "식물 카테고리"
        $0.font = .bodyB1
        $0.textColor = .gray4
    }
    private let plantCategoryVStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.spacing = 24
    }
    private let hStackView1 = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    private let hStackView2 = UIStackView().then {
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.spacing = 16
    }
    private let popularSearchWordLabel = UILabel().then {
        $0.text = "인기검색어"
        $0.font = .bodyB1
        $0.textColor = .gray4
    }
    private let referenceDateLabel = UILabel().then {
        $0.font = .bodyM3
        $0.textColor = .gray5
    }
    private let flowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.minimumInteritemSpacing = 0
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 108)
    }
    private lazy var popularSearchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
        $0.isScrollEnabled = false
        $0.clipsToBounds = false
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setStackView()
        configureUI()
        setBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    // MARK: - Custom Method
        
        let halfCount = viewModel.categories.count / 2
        for (index, category) in viewModel.categories.enumerated() {
            let categoryView = CategoryView(category: category)
            if index < halfCount {
                hStackView1.addArrangedSubview(categoryView)
            } else {
                hStackView2.addArrangedSubview(categoryView)
            }
            
            categoryView.button.rx.tap
                .map { category }
                .bind(to: selectCategorySubject)
                .disposed(by: disposeBag)
        }
    }
    
    private func setBindings() {
        let input = PlantInfoViewModel.Input(
            selectCategory: selectCategorySubject
        )
        
        let output = viewModel.transform(input: input)
        
        output.selectedCategory
            .drive(onNext: { category in
                self.navigateToCategoryView(colorName: category.color, title: category.label)
            })
            .disposed(by: disposeBag)
        
        output.firstDayOfMonth
            .drive(referenceDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.numberOfItems
            .drive(onNext: { [weak self] itemCount in
                self?.updateCollectionViewHeight(itemCount: itemCount)
            })
            .disposed(by: disposeBag)
        
        setPopularSearchCollectionView(output: output)
    }
    
    private func navigateToCategoryView(colorName: String, title: String) {
        let detailVC = PlantCetegoryViewController()
        detailVC.navigationBackgroundColor = colorName
        detailVC.navigationItem.title = title
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func setStackView() {
        plantCategoryVStackView.addArrangedSubview(hStackView1)
        plantCategoryVStackView.addArrangedSubview(hStackView2)
        
        let halfCount = viewModel.categories.count / 2
        for (index, category) in viewModel.categories.enumerated() {
            let categoryView = CategoryView(category: category)
            if index < halfCount {
                hStackView1.addArrangedSubview(categoryView)
            } else {
                hStackView2.addArrangedSubview(categoryView)
            }
            
            categoryView.button.rx.tap
                .map { category }
                .bind(to: selectCategorySubject)
                .disposed(by: disposeBag)
        }
    }
    
    // MARK: - Popular Search CollectionView
    private func setPopularSearchCollectionView(output: PlantInfoViewModel.Output) {
        popularSearchCollectionView.register(PopularSearchCollectionViewCell.self, forCellWithReuseIdentifier: PopularSearchCollectionViewCell.identifier)
        
        output.popularSearchWords
            .drive(popularSearchCollectionView.rx.items(cellIdentifier: PopularSearchCollectionViewCell.identifier, cellType: PopularSearchCollectionViewCell.self)) { _, element, cell in
                cell.setAttributes(with: element)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateCollectionViewHeight(itemCount: Int) {
        let height = CGFloat(itemCount) * popularSearchCollectionViewCellHeight
        popularSearchCollectionView.snp.updateConstraints { make in
            make.height.equalTo(height)
        }
    }
}

// MARK: - UI
extension PlantInfoViewController {
    private func configureUI() {
        self.view.backgroundColor = .white
        setConstraints()
        setSearchController()
    }
    
    private func setNavigationBar() {
        self.navigationItem.title = "식물 정보"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyM1]
        
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        backBarButtonItem.tintColor = .gray6
        self.navigationItem.backBarButtonItem = backBarButtonItem
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        self.navigationItem.searchController = searchController
        // TODO: 다른 화면 선택 시 searchBar 편집 끝내기 처리
    }
    
    private func setSearchController() {
        searchController.searchResultsUpdater = searchResultController
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.font = .bodyM1
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "식물을 입력해 주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray3!])
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.setImage(UIImage(named: "Reset"), for: .clear, state: .normal)
    }
    
    private func setConstraints() {
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        searchController.searchBar.addSubview(borderLineView)
        
        [plantCategoryLabel, plantCategoryVStackView, popularSearchWordLabel, referenceDateLabel, popularSearchCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        borderLineView.snp.makeConstraints {
            $0.bottom.equalTo(searchController.searchBar)
            $0.leading.equalTo(searchController.searchBar)
            $0.trailing.equalTo(searchController.searchBar)
            $0.height.equalTo(1)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        plantCategoryLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalToSuperview().offset(24)
        }
        
        plantCategoryVStackView.snp.makeConstraints {
            $0.height.equalTo(176)
            $0.top.equalTo(plantCategoryLabel.snp.bottom).offset(18)
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
        }
        
        popularSearchWordLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.leading.equalTo(plantCategoryVStackView)
            $0.top.equalTo(plantCategoryVStackView.snp.bottom).offset(50)
        }
        
        referenceDateLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.trailing.equalTo(plantCategoryVStackView)
            $0.top.equalTo(plantCategoryVStackView.snp.bottom).offset(52)
        }
        
        popularSearchCollectionView.snp.makeConstraints {
            $0.height.equalTo(0)
            $0.top.equalTo(popularSearchWordLabel.snp.bottom).offset(18)
            $0.leading.equalTo(contentView).offset(20)
            $0.trailing.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView)
        }
    }
}
