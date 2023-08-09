//
//  Main.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/08.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, UICollectionViewDelegate {
    // MARK: - Properties
    private let viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    
    // MARK: - UI Components
    let scrollView = UIScrollView()
    let emptyView = UIView()
    let contentView = UIView()
    let topView = UIView()
    let userNameLabel = UILabel()
    let label1 = UILabel()
    let label2 = UILabel()
    let label2Shadowview = UIView()
    let gradientView = UIView()
    let potImageView = UIImageView()
    let myPlaceLabel = UILabel()
    let addPlaceButton = UIButton()
    let friendRequestButton = UIButton()
    let myPlantLabel = UILabel()
    let addPlantButton = UIButton()
    lazy var myPlaceCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = CGSize(width: 250, height: 156)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    lazy var myPlantCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.itemSize = CGSize(width: 164, height: 132)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        configureUI()
        view.layoutIfNeeded()
        setGradient()
        bindCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1)
    }
        
    // MARK: - CollectionView
    private func bindCollectionView() {
        viewModel.mainObservable
            .flatMap { mainModels -> Observable<[Place]> in
                let places = mainModels.flatMap { $0.placeList }
                return Observable.just(places)
            }
            .bind(to: myPlaceCollectionView.rx.items(cellIdentifier: MainMyPlaceCollectionViewCell.identifier, cellType: MainMyPlaceCollectionViewCell.self)) { _, place, cell in
                cell.setAttributes(with: place)
                if place.placeImage == "addPlaceCellFirstImage" {
                    cell.disableGradient()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.mainObservable
            .flatMap { mainModels -> Observable<[Plant]> in
                let plants = mainModels.flatMap { $0.plantList }
                return Observable.just(plants)
            }
            .bind(to: myPlantCollectionView.rx.items(cellIdentifier: MainMyPlantCollectionViewCell.identifier, cellType: MainMyPlantCollectionViewCell.self)) { _, plant, cell in
                cell.setAttributes(with: plant)
            }
            .disposed(by: disposeBag)
    }
    
    private func setCollectionView() {
        self.myPlaceCollectionView.register(MainMyPlaceCollectionViewCell.self, forCellWithReuseIdentifier: MainMyPlaceCollectionViewCell.identifier)
        self.myPlantCollectionView.register(MainMyPlantCollectionViewCell.self, forCellWithReuseIdentifier: MainMyPlantCollectionViewCell.identifier)
        myPlaceCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        myPlantCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// MARK: - UI
extension MainViewController {
    private func configureUI() {
        setAttributes()
        setConstraints()
    }
    
    private func setGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = gradientView.bounds
        let colors: [CGColor] = [
            UIColor(red: 0.85, green: 0.87, blue: 0.87, alpha: 0.6).cgColor,
            UIColor(red: 0.85, green: 0.87, blue: 0.87, alpha: 0).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientView.layer.masksToBounds = true
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    private func setAttributes() {
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        contentView.backgroundColor = .white
        
        topView.backgroundColor = UIColor(red: 0.95, green: 0.96, blue: 0.96, alpha: 1)
        
        userNameLabel.text = "커먼"
        userNameLabel.font = .bodyB2
        userNameLabel.textColor = UIColor(red: 0.3, green: 0.37, blue: 0.35, alpha: 1)
        
        label1.text = "님과 함께 친환경 한 걸음을"
        label1.textColor = .black
        label1.font = .head6
        
        label2.text = "한걸음에"
        label2.font = .head6
        label2.textColor = .seaGreenDark3
        
        label2Shadowview.backgroundColor = UIColor(red: 0.3, green: 0.37, blue: 0.35, alpha: 0.16)
        
        potImageView.image = UIImage(named: "mainPodImg")
        potImageView.contentMode = .scaleAspectFit
        
        myPlaceLabel.text = "My Place"
        myPlaceLabel.font = .head5
        myPlaceLabel.textColor = .black
        
        addPlaceButton.setImage(UIImage(named: "mainAddBtn"), for: .normal)
        
        friendRequestButton.setTitle("요청 1건", for: .normal)
        friendRequestButton.tintColor = .white
        friendRequestButton.titleLabel?.font = .bodyB3
        friendRequestButton.backgroundColor = .seaGreenDark1
        friendRequestButton.layer.cornerRadius = 8
        
        myPlaceCollectionView.showsHorizontalScrollIndicator = false
        
        myPlantLabel.text = "My Plant"
        myPlantLabel.font = .head5
        myPlantLabel.textColor = .black
        
        addPlantButton.setImage(UIImage(named: "mainAddBtn"), for: .normal)
        
        myPlantCollectionView.showsHorizontalScrollIndicator = false
    }
    
    private func setConstraints() {
        self.view.addSubview(scrollView)
        self.view.addSubview(emptyView)
        scrollView.addSubview(contentView)
        [topView, myPlaceLabel, addPlaceButton, friendRequestButton,  friendRequestButton, myPlaceCollectionView, myPlantLabel, addPlantButton, myPlantCollectionView].forEach {
            contentView.addSubview($0)
        }
        
        [userNameLabel, label1, label2, label2Shadowview, gradientView, potImageView].forEach {
            topView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
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
        
        topView.snp.makeConstraints {
            $0.top.left.right.equalTo(contentView)
            $0.height.equalTo(200)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(46)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(22)
        }
        
        label1.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(6)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(24)
        }
        
        label2.snp.makeConstraints {
            $0.top.equalTo(label1.snp.bottom).offset(6)
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(24)
        }
        
        label2Shadowview.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(20)
            $0.height.equalTo(10)
            $0.width.equalTo(70)
            $0.bottom.equalTo(label2)
        }
        
        gradientView.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(27.6)
            $0.bottom.equalTo(topView.snp.bottom).offset(-11)
        }
        
        potImageView.snp.makeConstraints {
            $0.right.equalTo(topView.snp.right).offset(-23)
            $0.top.equalTo(topView.snp.top).offset(110)
            $0.height.equalTo(64)
            $0.width.equalTo(88)
        }
        
        myPlaceLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.top.equalTo(topView.snp.bottom).offset(24)
            $0.height.equalTo(32)
        }
        
        addPlaceButton.snp.makeConstraints {
            $0.right.equalTo(contentView.snp.right).offset(-13)
            $0.top.equalTo(topView.snp.bottom).offset(36)
            $0.height.width.equalTo(36)
        }
        
        friendRequestButton.snp.makeConstraints {
            $0.right.equalTo(addPlaceButton.snp.left).offset(-8)
            $0.top.equalTo(topView.snp.bottom).offset(36)
            $0.width.equalTo(96)
            $0.height.equalTo(36)
        }
        
        myPlaceCollectionView.snp.makeConstraints {
            $0.height.equalTo(156)
            $0.top.equalTo(friendRequestButton.snp.bottom).offset(10)
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.right.equalToSuperview()
        }
        
        myPlantLabel.snp.makeConstraints {
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.top.equalTo(myPlaceCollectionView.snp.bottom).offset(32)
            $0.height.equalTo(32)
        }
        
        addPlantButton.snp.makeConstraints {
            $0.right.equalTo(contentView.snp.right).offset(-13)
            $0.top.equalTo(myPlaceCollectionView.snp.bottom).offset(44)
            $0.height.width.equalTo(36)
        }
        
        myPlantCollectionView.snp.makeConstraints {
            $0.height.equalTo(132)
            $0.top.equalTo(addPlantButton.snp.bottom).offset(10)
            $0.left.equalTo(contentView.snp.left).offset(20)
            $0.right.equalToSuperview()
            $0.bottom.equalTo(contentView).offset(-10)
        }
    }
}
