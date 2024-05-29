//
//  CetegoryDetailViewController.swift
//  CommonPlant
//
//  Created by 이예원 on 5/25/24.
//

import UIKit
import Then
import SnapKit

class CetegoryDetailViewController: UIViewController {
    // MARK: UIComponents
    private let scrollView = UIScrollView().then {
        $0.backgroundColor = .white
    }
    private let contentView = UIView()
    private let imageView = UIImageView().then {
        $0.makeRound(radius: 16)
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    private let plantKoreanName = UILabel().then {
        $0.text = "몬테"
        $0.font = .head5
    }
    private let plantEnglishName = UILabel().then {
        $0.text = "Monstera deliciosa"
        $0.font = .bodyM2
        $0.textColor = .gray6
    }
    private let dividerView1 = UILabel().then {
        $0.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    }
    private let plantInfoLabel = UILabel().then {
        $0.text = "식물정보"
        $0.textColor = .gray4
        $0.font = .bodyB1
    }
    private let infoBackgroundView = UIView().then {
        $0.makeRound(radius: 16)
        $0.backgroundColor = .seaGreen
    }
    private let waterDayImageView = UIImageView().then {
        $0.image = UIImage(named: "WateringPot")
    }
    private let sunlightImageView = UIImageView().then {
        $0.image = UIImage(named: "Sunlight")
    }
    private let temperatureImageView = UIImageView().then {
        $0.image = UIImage(named: "Temperature")
    }
    private let humidityInfoImageView = UIImageView().then {
        $0.image = UIImage(named: "Humidity")
    }
    private let wateringCycleLabel = UILabel().then {
        $0.textColor = .gray6
        $0.font = .captionM1
        $0.text = "10 Day"
    }
    private let sunlightInfoLabel = UILabel().then {
        $0.text = "밝은 곳을 좋아해요!"
        $0.textColor = .gray6
        $0.font = .captionM1
    }
    private let temperatureLabel = UILabel().then {
        $0.text = "16~20℃"
        $0.textColor = .gray6
        $0.font = .captionM1
    }
    private let humidityInfoLabel = UILabel().then {
        $0.text = "70% 이상"
        $0.textColor = .gray6
        $0.font = .captionM1
    }
    private let dividerView2 = UILabel().then {
        $0.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
    }
    private let plantGrowingTipLabel = UILabel().then {
        $0.text = "식물 키우기 Tip"
        $0.textColor = .gray4
        $0.font = .bodyB1
    }
    private let plantGrowingTipScrollView = UIScrollView().then {
        $0.backgroundColor = .white
        $0.clipsToBounds = false
        $0.showsHorizontalScrollIndicator = false
    }
    private let contentView2 = UIView()
    private let wateringTipView = UIView()
    private let placementTipView = UIView()
    private let managementTipView = UIView()
    private let wateringTipLabel = UILabel().then {
        $0.font = .bodyB2
        $0.text = "가을철 물주기"
    }
    private let wateringTipDetailLabel = UILabel().then {
        $0.font = .bodyM3
        $0.numberOfLines = 2
        $0.text = "흙을 촉촉하게 유지(물에 잠기지 않도록 주의)"
    }
    private let placementTipLabel = UILabel().then {
        $0.font = .bodyB2
        $0.text = "배치 장소"
    }
    private let placementTipDetailLabel = UILabel().then {
        $0.font = .bodyM3
        $0.numberOfLines = 3
        $0.text = "거실 내측\n거실 창측\n발코니 창측"
    }
    private let managementTipLabel = UILabel().then {
        $0.font = .bodyB2
        $0.text = "관리하기"
    }
    private let managementTipDetailLabel = UILabel().then {
        $0.font = .bodyM3
        $0.numberOfLines = 3
        $0.text = "수경은 물주기가 필요 없으나, 화분은 1-2주에 한번씩 충분히 관수한다."
    }
    // MARK: Properties
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setConstraints()
        view.backgroundColor = .white
        customShadow()
    }
    
    // MARK: Custom Methods
    
}

extension  CetegoryDetailViewController {
    private func customShadow() {
        [wateringTipView, placementTipView, managementTipView].forEach {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.shadowColor = UIColor(red: 0.471, green: 0.471, blue: 0.471, alpha: 0.25).cgColor
            $0.layer.shadowOffset = CGSize(width: 0, height: 1)
            $0.layer.shadowRadius = 4
            $0.layer.shadowOpacity = 1
        }
    }
    
    private func setConstraints() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        
        [imageView, plantKoreanName, plantEnglishName, dividerView1, plantInfoLabel, infoBackgroundView, dividerView2, plantGrowingTipLabel, plantGrowingTipScrollView].forEach {
            contentView.addSubview($0)
        }
        
        [waterDayImageView, sunlightImageView, temperatureImageView, humidityInfoImageView, wateringCycleLabel, sunlightInfoLabel, temperatureLabel, humidityInfoLabel].forEach {
            infoBackgroundView.addSubview($0)
        }
        
        plantGrowingTipScrollView.addSubview(contentView2)
        
        [wateringTipView, placementTipView, managementTipView].forEach {
            contentView2.addSubview($0)
        }
        
        [wateringTipLabel, wateringTipDetailLabel].forEach {
            wateringTipView.addSubview($0)
        }
        
        [placementTipLabel, placementTipDetailLabel].forEach {
            placementTipView.addSubview($0)
        }
        
        [managementTipLabel, managementTipDetailLabel].forEach {
            managementTipView.addSubview($0)
        }
        
        scrollView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView)
            $0.width.equalTo(scrollView)
        }

        imageView.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(16)
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.height.equalTo(imageView.snp.width).multipliedBy(208.0/335.0)
        }
        
        plantKoreanName.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(imageView.snp.bottom).offset(8)
        }
        
        plantEnglishName.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.centerX.equalTo(contentView)
            $0.top.equalTo(plantKoreanName.snp.bottom)
        }
        
        dividerView1.snp.makeConstraints {
            $0.height.equalTo(8)
            $0.left.right.equalTo(contentView)
            $0.top.equalTo(plantEnglishName.snp.bottom).offset(32)
        }
        
        plantInfoLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.top.equalTo(dividerView1.snp.bottom).offset(16)
            $0.left.equalTo(contentView.snp.left).offset(30)
        }
        
        infoBackgroundView.snp.makeConstraints {
            $0.left.equalTo(contentView).offset(20)
            $0.right.equalTo(contentView).offset(-20)
            $0.top.equalTo(plantInfoLabel.snp.bottom).offset(12)
        }
        
        waterDayImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
        }
        
        sunlightImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
            $0.top.equalTo(waterDayImageView.snp.bottom).offset(12)
        }
        
        temperatureImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
            $0.top.equalTo(sunlightImageView.snp.bottom).offset(12)
        }
        
        humidityInfoImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.width.height.equalTo(24)
            $0.top.equalTo(temperatureImageView.snp.bottom).offset(12)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        wateringCycleLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.equalTo(waterDayImageView.snp.right).offset(8)
            $0.centerY.equalTo(waterDayImageView)
        }
        
        sunlightInfoLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.equalTo(wateringCycleLabel.snp.left)
            $0.centerY.equalTo(sunlightImageView)
        }
        
        temperatureLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.equalTo(wateringCycleLabel.snp.left)
            $0.centerY.equalTo(temperatureImageView)
        }
        
        humidityInfoLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.equalTo(wateringCycleLabel.snp.left)
            $0.centerY.equalTo(humidityInfoImageView)
        }
        
        dividerView2.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.height.equalTo(8)
            $0.top.equalTo(infoBackgroundView.snp.bottom).offset(32)
        }
        
        plantGrowingTipLabel.snp.makeConstraints {
            $0.height.equalTo(24)
            $0.left.equalToSuperview().offset(30)
            $0.top.equalTo(dividerView2.snp.bottom).offset(16)
        }
        
        plantGrowingTipScrollView.snp.makeConstraints {
            $0.height.equalTo(121)
            $0.left.equalToSuperview().offset(20)
            $0.top.equalTo(plantGrowingTipLabel.snp.bottom).offset(20)
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-48)
        }
        
        contentView2.snp.makeConstraints {
            $0.edges.equalTo(plantGrowingTipScrollView)
            $0.height.equalTo(plantGrowingTipScrollView)
        }
        
        wateringTipView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(121)
            $0.top.bottom.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        placementTipView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(121)
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(wateringTipView.snp.right).offset(10)
        }
        
        managementTipView.snp.makeConstraints {
            $0.width.equalTo(164)
            $0.height.equalTo(121)
            $0.top.bottom.equalToSuperview()
            $0.left.equalTo(placementTipView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-20)
        }
        
        wateringTipLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(22)
        }
        
        wateringTipDetailLabel.snp.makeConstraints {
            $0.left.equalTo(wateringTipLabel.snp.left)
            $0.right.equalToSuperview().offset(14)
            $0.top.equalTo(wateringTipLabel.snp.bottom).offset(4)
            $0.height.equalTo(40)
        }
        
        placementTipLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(22)
        }
        
        placementTipDetailLabel.snp.makeConstraints {
            $0.left.equalTo(placementTipLabel.snp.left)
            $0.top.equalTo(placementTipLabel.snp.bottom).offset(4)
        }
        
        managementTipLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(14)
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(22)
        }
        
        managementTipDetailLabel.snp.makeConstraints {
            $0.left.equalTo(managementTipLabel.snp.left)
            $0.right.equalToSuperview().offset(-14)
            $0.top.equalTo(managementTipLabel.snp.bottom).offset(4)
            $0.bottom.equalToSuperview().offset(-19)
        }
    }
}
