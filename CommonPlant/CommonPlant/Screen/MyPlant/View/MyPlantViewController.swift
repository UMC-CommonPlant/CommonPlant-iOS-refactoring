//
//  MyPlantViewController.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/25.
//

import UIKit

class MyPlantViewController: UIViewController {
    // MARK: Properties
    var countDate: Int = 0
    var wateringCycle: Int = 0
    var minTemperature: Int = 0
    var maxTemperature: Int = 0
    
    // MARK: UIComponents
    var scrollView = UIScrollView()
    var stackView = UIStackView()
    var backButton = UIButton()
    var plantProfileView = UIView()
    var plantImageView = UIImageView()
    var placeNameLabel = UILabel()
    var nickNameLabel = UILabel()
    var scientificNameLabel = UILabel()
    var dateInfoView = UIView()
    var countingMessageLabe = UILabel()
    var wateringImageView = UIImageView()
    var waterDayLabel = UILabel()
    var metMessageLabel = UILabel()
    var metDateLabel = UILabel()
    var lastWateringMessageLabel = UILabel()
    var lastWateringDateLabel = UILabel()
    var memoView = UIView()
    var memoTitleLabel = UILabel()
    lazy var memoCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 8
        flowLayout.itemSize = CGSize(width: self.view.bounds.width, height: 174)
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .clear
        return view
    }()
    var addMemoButton = UIButton()
    var plantInfoView = UIView()
    var backgroundView = UIView()
    var wateringCycleImage = UIImageView()
    var wateringCycleLabel = UILabel()
    var sunlightImage = UIImage()
    var sunlightInfoLabel = UILabel()
    var temperInfoImage = UIImage()
    var temperInfoLabel = UILabel()
    var humidityInfoImage = UIImage()
    var humidityInfoLabel = UILabel()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
