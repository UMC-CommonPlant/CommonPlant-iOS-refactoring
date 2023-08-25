//
//  MyPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/25.
//

import UIKit
import RxSwift
class MyPlantViewController: UIViewController {
    // MARK: Properties
    let viewModel = MyPlantViewModel()
    let disposeBag = DisposeBag()
    
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
    var wateringImageView = UIImageView()
    var waterDayLabel = UILabel()
    var metMessageLabel = UILabel()
    var metDateLabel = UILabel()
    var lastWateringMessageLabel = UILabel()
    var lastWateringDateLabel = UILabel()
    var memoView = UIView()
    var memoTitleLabel = CommonLabel()
    var nextButton = UIButton()
    lazy var memoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.itemSize = CGSize(width: self.view.bounds.width, height: 174)
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
        self.view.backgroundColor = .gray1
        self.navigationItem.title = "My Plant"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.bodyM1, .foregroundColor: UIColor.gray6 as Any]
    }
    
    // MARK: Custom Methods
    func setAttributes() {
        let plantData = viewModel.myPlant
        var nextBtnConfig = UIButton.Configuration.plain()
        var addBtnConfig = UIButton.Configuration.plain()
        
        stackView.backgroundColor = .white
        
        plantImageView.load(url: URL(string: plantData.imgURL)!)
        
        placeView.backgroundColor = .seaGreenDark3
        
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
        
        memoTitleLabel.text = "Memo"
        memoTitleLabel.textColor = .gray4
        memoTitleLabel.font = .bodyB1
        memoTitleLabel.padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 0)
        
        nextBtnConfig.image = UIImage(named: "Next")
        nextButton.configuration = nextBtnConfig
        
        var addMemoAttr = AttributedString.init("작성하기")
        addMemoAttr.font = .bodyB3
        addMemoAttr.foregroundColor = .white
        addBtnConfig.attributedTitle = addMemoAttr
        
        addMemoButton.configuration = addBtnConfig
        addMemoButton.contentHorizontalAlignment = .center
        addMemoButton.backgroundColor = .seaGreenDark1
        addMemoButton.makeRound(radius: 8)
        
        infoTitleLabel.text = "식물정보"
        infoTitleLabel.textColor = .gray4
        infoTitleLabel.font = .bodyB1
        infoTitleLabel.padding = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 0)
        
        backgroundView.backgroundColor = .seaGreen
        
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
        
        [countingMessageLabel, wateringImageView, waterDayLabel, metMessageLabel, metDateLabel, lastWateringMessageLabel, lastWateringDateLabel].forEach {
            dateInfoView.addSubview($0)
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
}
