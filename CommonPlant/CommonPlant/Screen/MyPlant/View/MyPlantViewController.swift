//
//  MyPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/25.
//

import UIKit
import RxSwift
import SnapKit
import Kingfisher

class MyPlantViewController: UIViewController {
    // MARK: Properties
    let viewModel = MyPlantViewModel()
    let disposeBag = DisposeBag()
    let identifier = MemoCardCollectionViewCell.identifier
    
    // MARK: UIComponents
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var backButton = UIButton()
    var plantProfileView = UIView()
    var menuButton = UIButton()
    var plantImageView = UIImageView()
    var placeView = UIView()
    var placeImageView = UIImageView()
    var placeNameLabel = UILabel()
    var nickNameLabel = UILabel()
    var scientificNameLabel = UILabel()
    var dateInfoView = UIView()
    var countingMessageLabel = UILabel()
    var wateringView = UIView()
    var wateringImageView = UIImageView()
    var waterDayLabel = UILabel()
    var infoView = UIView()
    var messageView = UIView()
    var dateView = UIView()
    var metMessageLabel = UILabel()
    var metDateLabel = UILabel()
    var lastWateringMessageLabel = UILabel()
    var lastWateringDateLabel = UILabel()
    var memoView = UIView()
    var memoTitleLabel = CommonLabel()
    var nextButton = UIButton()
    lazy var memoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = CGSize(width: 250, height: 174)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 20, bottom: 0, right: 20)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    var addMemoButton = UIButton()
    var plantInfoView = UIView()
    var infoTitleLabel = CommonLabel()
    var backgroundView = UIView()
    var wateringCycleImage = UIImageView()
    var wateringCycleLabel = UILabel()
    var cautionLabel = UILabel()
    var sunlightImageView = UIImageView()
    var sunlightInfoLabel = UILabel()
    var temperatureImageView = UIImageView()
    var temperatureLabel = UILabel()
    var humidityInfoImageView = UIImageView()
    var humidityInfoLabel = UILabel()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.memoCollectionView.delegate = self
        self.memoCollectionView.dataSource = self
        
        setNavigationBar()
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    // MARK: Custom Methods
    func setNavigationBar() {
        self.navigationItem.title = "My Plant"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyB1, .foregroundColor: UIColor.gray6 as Any]
        self.navigationController?.navigationBar.barTintColor = .white
    }
    
    func setAttributes() {
        let plantData = viewModel.myPlant
        
        var menuBtnConfig = UIButton.Configuration.plain()
        var nextBtnConfig = UIButton.Configuration.plain()
        var addBtnConfig = UIButton.Configuration.plain()
        
        stackView.backgroundColor = .gray1
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        
        if let imageURL = URL(string: plantData.imgURL) {
            plantImageView.load(url: imageURL)
        } else {
            plantImageView.image = UIImage(named: "plant1")
        }
        
        menuBtnConfig.image = UIImage(named: "Menu")
        menuButton.configuration = menuBtnConfig
        
        plantProfileView.backgroundColor = .white
        
        placeView.backgroundColor = .seaGreenDark3
        placeView.makeRound(radius: 8)
        
        placeImageView.image = UIImage(named: "Place")
        
        placeNameLabel.text = "\(plantData.place)"
        placeNameLabel.textColor = .white
        placeNameLabel.font = .bodyB3
        
        nickNameLabel.text = "\(plantData.nickname)"
        nickNameLabel.textColor = .black
        nickNameLabel.font = .head5
        nickNameLabel.textAlignment = .center
        
        scientificNameLabel.text = "\(plantData.scientificName)"
        scientificNameLabel.textColor = .gray6
        scientificNameLabel.font = .bodyM2
        scientificNameLabel.textAlignment = .center
        
        dateInfoView.backgroundColor = .white
        
        countingMessageLabel.text = "\(plantData.nickname)와(과) 함께한지 \(plantData.countDate)일이 지났어요!"
        countingMessageLabel.partiallyChanged(targetString: "\(plantData.countDate)일", font: .bodyB1, color: .gray6)
        countingMessageLabel.textColor = .gray5
        countingMessageLabel.font = .bodyM2
        countingMessageLabel.textAlignment = .center
        
        wateringImageView.image = UIImage(named: "WateringCan")
        
        waterDayLabel.text = "D\(plantData.remainderDate)"
        waterDayLabel.textColor = .gray6
        waterDayLabel.font = .head4
        waterDayLabel.textAlignment = .center
        
        metMessageLabel.text = "처음 함께한 날"
        metMessageLabel.textColor = .gray4
        metMessageLabel.font = .captionM1
        metMessageLabel.textAlignment = .center
        
        metDateLabel.text = plantData.createdAt
        metDateLabel.textColor = .gray4
        metDateLabel.font = .captionM1
        metDateLabel.textAlignment = .center
        
        lastWateringMessageLabel.text = "마지막으로 물 준 날짜"
        lastWateringMessageLabel.textColor = .gray4
        lastWateringMessageLabel.font = .captionM1
        lastWateringMessageLabel.textAlignment = .center
        
        lastWateringDateLabel.text = plantData.wateredDate
        lastWateringDateLabel.textColor = .gray4
        lastWateringDateLabel.font = .captionM1
        lastWateringDateLabel.textAlignment = .center
        
        memoView.backgroundColor = .white
        
        memoTitleLabel.text = "Memo"
        memoTitleLabel.textColor = .gray4
        memoTitleLabel.font = .bodyB1
        memoTitleLabel.padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 0)
        
        nextBtnConfig.image = UIImage(named: "Next")
        nextButton.configuration = nextBtnConfig
        
        memoCollectionView.register(MemoCardCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        
        var addMemoAttr = AttributedString.init("작성하기")
        addMemoAttr.font = .bodyB3
        addBtnConfig.attributedTitle = addMemoAttr
        addBtnConfig.baseForegroundColor = .white
        
        addMemoButton.configuration = addBtnConfig
        addMemoButton.contentHorizontalAlignment = .center
        addMemoButton.backgroundColor = .seaGreenDark1
        addMemoButton.makeRound(radius: 8)
        
        plantInfoView.backgroundColor = .white
        
        infoTitleLabel.text = "식물정보"
        infoTitleLabel.textColor = .gray4
        infoTitleLabel.font = .bodyB1
        infoTitleLabel.padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 0)
        
        backgroundView.backgroundColor = .seaGreen
        backgroundView.makeRound(radius: 16)
        
        wateringCycleImage.image = UIImage(named: "WateringPot")
        
        wateringCycleLabel.text = "\(plantData.waterDay) Day"
        wateringCycleLabel.textColor = .gray6
        wateringCycleLabel.font = .captionM1
        wateringCycleLabel.textAlignment = .left
        
        cautionLabel.text = "물을 좋아하나 과습에 주의하세요!" // 현재 api에 없는 값!
        cautionLabel.textColor = .gray5
        cautionLabel.font = .captionM2
        cautionLabel.textAlignment = .center
        
        sunlightImageView.image = UIImage(named: "Sunlight")
        
        sunlightInfoLabel.text = "\(plantData.sunlight)"
        sunlightInfoLabel.textColor = .gray6
        sunlightInfoLabel.font = .captionM1
        sunlightInfoLabel.textAlignment = .left
        
        temperatureImageView.image = UIImage(named: "Temperature")
        
        temperatureLabel.text = "\(plantData.tempMin)~\(plantData.tempMax)℃"
        temperatureLabel.textColor = .gray6
        temperatureLabel.font = .captionM1
        temperatureLabel.textAlignment = .left
        
        humidityInfoImageView.image = UIImage(named: "Humidity")
        
        humidityInfoLabel.text = "\(plantData.humidity)"
        humidityInfoLabel.textColor = .gray6
        humidityInfoLabel.font = .captionM1
        humidityInfoLabel.textAlignment = .left
    }
    
    func setHierarchy() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        [plantProfileView, dateInfoView, memoView, plantInfoView].forEach {
            stackView.addArrangedSubview($0)
        }
        
        [menuButton, plantImageView, placeView, nickNameLabel, scientificNameLabel].forEach {
            plantProfileView.addSubview($0)
        }
        
        [placeImageView, placeNameLabel].forEach {
            placeView.addSubview($0)
        }
        
        [countingMessageLabel, wateringView, infoView].forEach {
            dateInfoView.addSubview($0)
        }
        
        [wateringImageView, waterDayLabel].forEach {
            wateringView.addSubview($0)
        }
        
        [messageView, dateView].forEach {
            infoView.addSubview($0)
        }
        
        [metMessageLabel, lastWateringMessageLabel].forEach {
            messageView.addSubview($0)
        }
        
        [metDateLabel, lastWateringDateLabel].forEach {
            dateView.addSubview($0)
        }
        
        [memoTitleLabel, nextButton, memoCollectionView, addMemoButton].forEach {
            memoView.addSubview($0)
        }
        
        [infoTitleLabel, backgroundView].forEach {
            plantInfoView.addSubview($0)
        }
        
        [wateringCycleImage, wateringCycleLabel, cautionLabel, sunlightImageView, sunlightInfoLabel, temperatureImageView, temperatureLabel, humidityInfoImageView, humidityInfoLabel].forEach {
            backgroundView.addSubview($0)
        }
    }
    
    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.bottom.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(scrollView)
            make.width.equalToSuperview()
            make.height.greaterThanOrEqualToSuperview().priority(.low)
        }
        
        plantProfileView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(322)
        }
        
        menuButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.height.equalTo(32)
        }
        
        plantImageView.snp.makeConstraints { make in
            make.top.equalTo(menuButton.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(208)
        }
        
        placeView.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.top).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.leading.equalToSuperview().offset(10)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(placeImageView.snp.trailing).offset(4)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(32)
        }
        
        scientificNameLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.centerX.equalToSuperview()
        }
        
        dateInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(172)
        }
        
        countingMessageLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
        }
        
        wateringView.snp.makeConstraints { make in
            make.top.equalTo(countingMessageLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(36)
        }
        
        wateringImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        waterDayLabel.snp.makeConstraints { make in
            make.leading.equalTo(wateringImageView.snp.trailing).offset(8)
            make.centerY.trailing.equalToSuperview()
        }
        
        infoView.snp.makeConstraints { make in
            make.top.equalTo(wateringView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
        messageView.snp.makeConstraints { make in
            make.top.leading.bottom.equalToSuperview()
        }
        
        dateView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(messageView.snp.trailing).offset(34)
        }
        
        metMessageLabel.snp.makeConstraints { make in
            make.top.leading.centerX.equalToSuperview()
        }
        
        lastWateringMessageLabel.snp.makeConstraints { make in
            make.top.equalTo(metMessageLabel.snp.bottom)
            make.leading.bottom.centerX.equalToSuperview()
        }
        
        metDateLabel.snp.makeConstraints { make in
            make.top.trailing.centerX.equalToSuperview()
        }
        
        lastWateringDateLabel.snp.makeConstraints { make in
            make.top.equalTo(metDateLabel.snp.bottom)
            make.trailing.bottom.centerX.equalToSuperview()
        }
        
        memoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(316)
        }
        
        nextButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.trailing.equalToSuperview().offset(-20)
            make.width.height.equalTo(48)
        }
        
        memoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalTo(nextButton.snp.leading)
        }
        
        memoCollectionView.snp.makeConstraints { make in
            make.top.equalTo(memoTitleLabel.snp.bottom).offset(4)
            make.width.equalToSuperview()
            make.height.equalTo(182)
        }
        
        addMemoButton.snp.makeConstraints { make in
            make.top.equalTo(memoCollectionView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(42)
        }
        
        plantInfoView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(274)
        }
        
        infoTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(4)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.top.equalTo(infoTitleLabel.snp.bottom)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(188)
        }
        
        wateringCycleImage.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }
        
        wateringCycleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(18)
            make.leading.equalTo(wateringCycleImage.snp.trailing).offset(8)
        }
        
        cautionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(46)
            make.top.equalTo(wateringCycleLabel.snp.bottom).offset(6)
        }
        
        sunlightImageView.snp.makeConstraints { make in
            make.top.equalTo(cautionLabel.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(16)
        }
        
        sunlightInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(sunlightImageView.snp.top).offset(2)
            make.leading.equalTo(sunlightImageView.snp.trailing).offset(8)
        }
        
        temperatureImageView.snp.makeConstraints { make in
            make.top.equalTo(sunlightImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureImageView.snp.top).offset(2)
            make.leading.equalTo(temperatureImageView.snp.trailing).offset(8)
        }
        
        humidityInfoImageView.snp.makeConstraints { make in
            make.top.equalTo(temperatureImageView.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(16)
        }
        
        humidityInfoLabel.snp.makeConstraints { make in
            make.top.equalTo(humidityInfoImageView.snp.top).offset(2)
            make.leading.equalTo(humidityInfoImageView.snp.trailing).offset(8)
        }
    }
}

extension MyPlantViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.myPlant.memoList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MemoCardCollectionViewCell

        let memo = viewModel.myPlant.memoList[indexPath.row]
        
        if let profileURL = URL(string: memo.userImgURL) {
            cell.profileView.kf.setImage(with: profileURL)
        }
        
        cell.nickNameLabel.text = memo.userNickName
        
        cell.contentLabel.text = memo.content
        
        if let imageURLString = memo.imgURL {
            if let imageURL = URL(string: imageURLString) {
                cell.imageView.kf.setImage(with: imageURL)
            }
        }
        
        cell.dateLabel.text = memo.createdAt
        
        return cell
    }
}
