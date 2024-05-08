//
//  MyPlaceViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 4/16/24.
//

import UIKit
import SnapKit
import Then
import JJFloatingActionButton

class MyPlaceViewController: UIViewController {
    // MARK: - UI Components
    private let topContentView = UIView().then {
        $0.layer.shadowColor = UIColor(red: 0.204, green: 0.204, blue: 0.204, alpha: 1).cgColor
        $0.layer.shadowOpacity = 0.3
        $0.layer.shadowRadius = 7
        $0.backgroundColor = .white
    }
    private let placeNameLabel = UILabel().then {
        $0.text = "스윗 홈 거실"
        $0.font = .head5
    }
    private let addressLabel = UILabel().then {
        $0.text = "서울특별시 고무래로 35"
        $0.textColor = .gray6
        $0.font = .bodyM2
    }
    private let temperatureImageView = UIImageView().then {
        $0.image = UIImage(named: "Sunlight")
    }
    private let humidityImageView = UIImageView().then {
        $0.image = UIImage(named: "Humidity")
    }
    private let temperatureLabel = UILabel().then {
        $0.text = "9.3 / 5"
        $0.font = .bodyM3
    }
    private let humidityLabel = UILabel().then {
        $0.text = "69%"
        $0.font = .bodyM3
    }    
    private lazy var friendsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: friendsCollectionViewFlowLayout).then {
        $0.backgroundColor = .seaGreenDark1
    }
    private let friendsCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 16
        $0.itemSize = CGSize(width: 56, height: 57)
    }
    private lazy var plantsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: plantsCollectionViewFlowLayout).then {
        $0.backgroundColor = .seaGreen
    }
    private let plantsCollectionViewFlowLayout = UICollectionViewFlowLayout().then {
        $0.scrollDirection = .vertical
        $0.minimumLineSpacing = 16
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width - 40, height: 136)
    }
    private let floatingButton = JJFloatingActionButton().then {
        $0.buttonImage = UIImage(named: "FloatingButton")
        $0.overlayView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        $0.buttonDiameter = 56
        $0.buttonImageSize = CGSize(width: 56, height: 56)
        $0.buttonAnimationConfiguration = .rotation(toAngle: 0)
        $0.itemSizeRatio = 1.0
    }
    private let leavePlaceAlertView = CommonAlertView().then {
        $0.setTitle("장소 나가기")
        $0.setMessage("장소에서 나가시겠습니까?")
        $0.setActionButton(title: "나가기")
        $0.isHidden = true
    }
    
    // MARK: - Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        addFloatingButtonItems()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        topContentView.layer.shadowPath = UIBezierPath(rect: CGRect(x: 0, y: 200, width: topContentView.bounds.width, height: 5)).cgPath
    }

    
    // MARK: - Custom Method
    private func addFloatingButtonItems() {
        floatingButton.addItem(title: "장소 나가기", image: UIImage(named: "LeavePlaceButton")?.withRenderingMode(.alwaysOriginal)) { _ in
            self.leavePlaceAlertView.isHidden = false
        }
        floatingButton.addItem(title: "식물 추가하기", image: UIImage(named: "AddPlantButton")?.withRenderingMode(.alwaysOriginal)) { _ in
            print("식물 추가하기")
        }
        floatingButton.addItem(title: "장소 수정하기", image: UIImage(named: "EditPalceInfoButton")?.withRenderingMode(.alwaysOriginal)) { _ in
            print("장소 수정하기")
        }
        floatingButton.addItem(title: "친구 관리하기", image: UIImage(named: "EditFriendsButton")?.withRenderingMode(.alwaysOriginal)) { _ in
            print("친구 관리하기")
        }
        floatingButton.configureDefaultItem { item in
            item.titleLabel.font = .bodyB2
            item.buttonColor = .clear
            item.imageSize = CGSize(width: 56, height: 56)
        }
    }
}

extension MyPlaceViewController {
    private func configureUI() {
        self.view.backgroundColor = .white
        self.tabBarController?.tabBar.isHidden = true
        setConstraints()
        setNavigationBar()
    }

    private func setNavigationBar() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.title = "My Place"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    private func setConstraints() {
        [topContentView, plantsCollectionView, floatingButton, leavePlaceAlertView].forEach {
            view.addSubview($0)
        }
        
        [placeNameLabel, addressLabel, temperatureImageView, humidityImageView, temperatureLabel, humidityLabel, friendsCollectionView].forEach {
            topContentView.addSubview($0)
        }
        
        topContentView.snp.makeConstraints {
            $0.leading.top.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(200)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.leading.equalTo(topContentView).offset(20)
            $0.top.equalTo(topContentView).offset(20)
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.leading.equalTo(placeNameLabel.snp.leading)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(8)
        }
        
        humidityImageView.snp.makeConstraints {
            $0.top.equalTo(topContentView).offset(23)
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(topContentView).offset(-20)
        }
        
        temperatureImageView.snp.makeConstraints {
            $0.top.equalTo(topContentView).offset(23)
            $0.width.height.equalTo(24)
            $0.trailing.equalTo(humidityImageView.snp.leading).offset(-25)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(temperatureImageView.snp.bottom).offset(8)
            $0.centerX.equalTo(temperatureImageView)
        }
        
        humidityLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerX.equalTo(humidityImageView)
            $0.top.equalTo(humidityImageView.snp.bottom).offset(8)
        }
        
        friendsCollectionView.snp.makeConstraints {
            $0.height.equalTo(57)
            $0.leading.equalTo(topContentView).offset(20)
            $0.trailing.equalToSuperview().offset(-24)
            $0.top.equalTo(addressLabel.snp.bottom).offset(34)
        }
        
        plantsCollectionView.snp.makeConstraints {
            $0.top.equalTo(topContentView.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(20)
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalToSuperview()
        }
        
        floatingButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-26)
            $0.width.height.equalTo(56)
        }
        
        leavePlaceAlertView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.height.equalTo(148)
            $0.left.equalToSuperview().offset(52.5)
            $0.right.equalToSuperview().offset(-52.5)
        }
    }
}
