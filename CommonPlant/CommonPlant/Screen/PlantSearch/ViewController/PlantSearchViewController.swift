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


class PlantSearchViewController: UIViewController, UITableViewDelegate {
    // MARK: - Properties
    private let collectionViewCellColor = ["OneRoomColor", "AirPurificationColor", "BeginnerColor", "SunlightColor", "WaterPreferenceColor", "InteriorColor"]
    private let collectionViewIcon = ["OneRoom", "AirPurification", "Beginner", "Sunlight", "WateringPot",  "Interior"]
    private let collectionViewCellLabelText = ["원룸", "공기정화", "초보집사", "채광", "물 주기", "인테리어"]
    
    private let viewModel = PlantSearchViewModel()
    private let disposeBag = DisposeBag()
    private lazy var viewWidth = view.frame.width
    
    
    // MARK: - UI Components
    let scrollView = UIScrollView()
    let contentView = UIView()
    let emptyView = UIView()
    let titleLable = UILabel()
    let customNavigationBar = UINavigationBar()
    let searchController = UISearchController(searchResultsController: nil)
    let borderLineView = UIView()
    let sampleLabel = UILabel()
    let plantCategoryCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 24
        flowLayout.itemSize = CGSize(width: 101, height: 76)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    let popularSearchWordLabel = UILabel()
    let referenceDateLabel = UILabel()
    lazy var popularSearchCollectionView: UICollectionView = {
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
        configureUI()
        setUpBindings()
        setCategoryCollectionView()
        setpPopularSearchCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        setNavigationbar()
    }
    
    // MARK: - Custom Method
    private func configureUI() {
        setAttributes()
        setConstraints()
    }
    
    private func setNavigationbar() {
        let navigationItem = UINavigationItem()
        customNavigationBar.setItems([navigationItem], animated: false)
        customNavigationBar.topItem?.searchController = searchController
        
        searchController.automaticallyShowsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.searchTextField.font = .bodyM1
        searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "식물을 입력해 주세요.", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray3!])
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.searchTextField.borderStyle = .none
        searchController.searchBar.searchTextField.leftView?.tintColor = .black
        searchController.searchBar.setImage(UIImage(named: "Reset"), for: .clear, state: .normal)
    }
    
    private func setUpBindings() {
        viewModel.referenceDate
            .bind(to: referenceDateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    // MARK: - Popular Search CollectionView
    private func setpPopularSearchCollectionView() {
        popularSearchCollectionView.register(PopularSearchCollectionViewCell.self, forCellWithReuseIdentifier: "PopularSearchCollectionViewCell")
        popularSearchCollectionView.rx.setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.plantSearchObservable
            .bind(to: popularSearchCollectionView.rx.items(cellIdentifier: PopularSearchCollectionViewCell.identifier, cellType: PopularSearchCollectionViewCell.self)) { _, element, cell in
                cell.setAttributes(with: element)
            }
            .disposed(by: disposeBag)
    }
}


// MARK: - CategoryCollectionView
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
        titleLable.text = "식물 정보"
        titleLable.font = .bodyM1
        
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
        [titleLable, customNavigationBar, borderLineView, scrollView, emptyView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [plantCategoryCollectionView, popularSearchWordLabel, referenceDateLabel, popularSearchCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        titleLable.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            $0.height.equalTo(24)
        }
        
        customNavigationBar.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(titleLable)
        }
        
        borderLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.right.equalToSuperview()
            $0.top.equalTo(customNavigationBar.snp.bottom)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(borderLineView.snp.bottom)
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        emptyView.snp.makeConstraints {
            $0.left.right.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(scrollView.snp.bottom)
            $0.bottom.equalTo(self.view)
            $0.height.equalTo(MainTabBarController.tabBarHeight)
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







import SwiftUI

struct Preview1: PreviewProvider {
    static var previews: some View {
        MainTabBarController().toPreview()
    }
}
