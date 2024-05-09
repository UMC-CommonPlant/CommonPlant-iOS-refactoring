//
//  PlantSearchViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxGesture

class PlantSearchViewController: UIViewController, UITableViewDelegate, UISearchControllerDelegate {
    // MARK: - Properties
    private let collectionViewCellColor = ["OneRoomColor", "AirPurificationColor", "BeginnerColor", "SunlightColor", "WaterPreferenceColor", "InteriorColor"]
    private let collectionViewIcon = ["OneRoom", "AirPurification", "Beginner", "Sunlight", "WateringPot",  "Interior"]
    private let collectionViewCellLabelText = ["원룸", "공기정화", "초보집사", "채광", "물 주기", "인테리어"]
    
    private let plantSearchViewModel = PlantSearchViewModel()
    private let disposeBag = DisposeBag()
    private lazy var viewWidth = view.frame.width
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let emptyView = UIView()
    private let searchResultController = SearchResultViewController()
    private lazy var searchController = UISearchController(searchResultsController: searchResultController)
    private let borderLineView = UIView()
    private let sampleLabel = UILabel()
    private let plantCategoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 24
        flowLayout.itemSize = CGSize(width: 101, height: 76)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    private let popularSearchWordLabel = UILabel()
    private let referenceDateLabel = UILabel()
    private lazy var popularSearchCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 16
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: self.viewWidth - 40, height: 108)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .seaGreen
        view.setCollectionViewLayout(flowLayout, animated: true)
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationItem.title = "식물 정보"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyM1]
        configureUI()
        setUpBindings()
        setSearchController()
        setCategoryCollectionView()
        setpPopularSearchCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
    }
    
    // MARK: - Custom Method
    private func configureUI() {
        setAttributes()
        setConstraints()
    }
    
    private func setSearchController() {
        self.navigationItem.searchController = searchController
        searchController.searchResultsUpdater = searchResultController
        
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.font = .bodyM1
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "식물을 입력해 주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray3!])
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.setImage(UIImage(named: "Reset"), for: .clear, state: .normal)
        
        view.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [weak self] _ in
                self?.searchController.searchBar.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    private func setUpBindings() {
        plantSearchViewModel.referenceDate
            .bind(to: referenceDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Popular Search CollectionView
    private func setpPopularSearchCollectionView() {
        popularSearchCollectionView.register(PopularSearchCollectionViewCell.self, forCellWithReuseIdentifier: "PopularSearchCollectionViewCell")
        popularSearchCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        plantSearchViewModel.plantSearchObservable
            .bind(to: popularSearchCollectionView.rx.items(cellIdentifier: PopularSearchCollectionViewCell.identifier, cellType: PopularSearchCollectionViewCell.self)) { _, element, cell in
                cell.setAttributes(with: element)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Category CollectionView
extension PlantSearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    private func setCategoryCollectionView() {
        self.plantCategoryCollectionView.dataSource = self
        self.plantCategoryCollectionView.delegate = self
        self.plantCategoryCollectionView.register(PlantSearchCollectionViewCell.self, forCellWithReuseIdentifier: PlantSearchCollectionViewCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlantSearchCollectionViewCell", for: indexPath) as! PlantSearchCollectionViewCell
        cell.background.backgroundColor = UIColor(named: collectionViewCellColor[indexPath.row])
        cell.label.text = collectionViewCellLabelText[indexPath.row]
        cell.icon.image = UIImage(named: collectionViewIcon[indexPath.row])
        return cell
    }
}
// MARK: - UI
extension PlantSearchViewController {
    private func setAttributes() {
        borderLineView.backgroundColor = .gray2
        
        contentView.backgroundColor = .white
        
        popularSearchWordLabel.text = "인기검색어"
        popularSearchWordLabel.font = .bodyB1
        popularSearchWordLabel.textColor = .gray4
        
        referenceDateLabel.text = "2023.8.1 기준"
        referenceDateLabel.font = .bodyM3
        referenceDateLabel.textColor = .gray5
        
        popularSearchCollectionView.isScrollEnabled = false
        popularSearchCollectionView.backgroundColor = .clear
        popularSearchCollectionView.clipsToBounds = false
    }
    
    private func setConstraints() {
        [scrollView, emptyView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        searchController.searchBar.addSubview(borderLineView)

        [plantCategoryCollectionView, popularSearchWordLabel, referenceDateLabel, popularSearchCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.view.safeAreaLayoutGuide)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
            $0.bottom.equalTo(self.view)
            $0.height.equalTo(MainTabBarController.tabBarHeight)
        }
        
        borderLineView.snp.makeConstraints {
            $0.bottom.equalTo(searchController.searchBar)
            $0.left.equalTo(searchController.searchBar)
            $0.right.equalTo(searchController.searchBar)
            $0.height.equalTo(1)
          }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }
        
        plantCategoryCollectionView.snp.makeConstraints {
            $0.height.equalTo(176)
            $0.top.equalTo(contentView).offset(24)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
        }
        
        popularSearchWordLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.left.equalTo(plantCategoryCollectionView)
            $0.top.equalTo(plantCategoryCollectionView.snp.bottom).offset(50)
        }
        
        referenceDateLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.right.equalTo(plantCategoryCollectionView)
            $0.top.equalTo(plantCategoryCollectionView.snp.bottom).offset(52)
        }
        
        popularSearchCollectionView.snp.makeConstraints {
            $0.height.equalTo(1230)
            $0.top.equalTo(popularSearchWordLabel.snp.bottom).offset(18)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.bottom.equalTo(contentView)
        }
    }
}
