//
//  PlantCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 4/17/24.
//

import UIKit

class PlantCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "PlantCollectionViewCell"
    
    // MARK: - UI Components
    private let plantImageView = UIImageView().then {
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
    }
    private let plantNicknameLabel = UILabel().then {
        $0.font = .bodyB2
    }
    private let plantNameLabel = UILabel().then {
        $0.font = .bodyM4
    }
    private let recentMemoLabel = UILabel().then {
        $0.font = .bodyM4
        $0.textColor = .gray5
    }
    private let wateringButton = UIButton().then {
        let image = UIImage(named: "wateringCan")
        $0.setImage(image, for: .normal)
        $0.layer.cornerRadius = 16
    }
    private let dDayLabel = UILabel().then {
        $0.textColor = .seaGreenDark2
        $0.font = .bodyB2
    }
    private let wateredDateLabel = UILabel().then {
        $0.textColor = .gray5
        $0.font = .bodyM4
    }
    
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setCellCorner()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setCellCorner() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0.471, green: 0.471, blue: 0.471, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.cornerRadius = 16
    }
    
    private func setConstraints() {
        [plantImageView, plantNicknameLabel, plantNameLabel, recentMemoLabel, wateringButton, dDayLabel, wateredDateLabel].forEach {
            self.addSubview($0)
        }
        
        plantImageView.snp.makeConstraints {
            $0.width.equalTo(136)
            $0.height.equalTo(108)
            $0.left.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(14)
            $0.bottom.equalToSuperview().offset(-14)
        }
        
        plantNicknameLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.left.equalTo(plantImageView.snp.right).offset(8)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalToSuperview().offset(10)
        }
        
        plantNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.left.equalTo(plantNicknameLabel.snp.left)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(plantNicknameLabel.snp.bottom)
        }
        
        recentMemoLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.left.equalTo(plantNicknameLabel.snp.left)
            $0.top.equalTo(plantNameLabel.snp.bottom).offset(4)
            $0.right.equalToSuperview().offset(-10)
        }
        
        wateringButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-10)
            $0.width.equalTo(72)
            $0.height.equalTo(40)
            $0.top.equalTo(recentMemoLabel.snp.bottom).offset(16)
        }
        
        dDayLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.top.equalTo(recentMemoLabel.snp.bottom).offset(16)
            $0.right.equalToSuperview().offset(-12)
        }
        
        wateredDateLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(dDayLabel.snp.bottom).offset(4)
            $0.right.equalTo(dDayLabel.snp.right)
        }
    }
}
