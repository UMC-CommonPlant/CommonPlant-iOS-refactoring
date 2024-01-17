//
//  PopularSearchCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/08/01.
//

import UIKit
import SnapKit

class PopularSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "PopularSearchCollectionViewCell"
    let plantImage = UIImageView()
    let nameLabel = UILabel()
    let scientificNameLabel = UILabel()
    let searchCountLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        setupCorner()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    private func configureCell() {
        setAttributes(with: PoplularSearchModel.init(plantImage: "", plantName: "", scientificName: "", searchCount: 0))
        setConstraints()
    }
    
    // MARK: - UI
    private func setupCorner() {
        self.backgroundColor = .white
        self.layer.shadowColor = UIColor(red: 0.471, green: 0.471, blue: 0.471, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        self.layer.cornerRadius = 16
    }
    
    func setAttributes(with model: PoplularSearchModel) {
        plantImage.layer.cornerRadius = 16
        plantImage.image = UIImage(named: model.plantImage)
        
        nameLabel.font = .bodyB2
        nameLabel.text = model.plantName
        
        scientificNameLabel.font = .bodyM4
        scientificNameLabel.text = model.scientificName
        scientificNameLabel.textColor = .gray5
        
        searchCountLabel.font = .bodyM4
        searchCountLabel.text = "지난달 \(model.searchCount)명이 검색"
        searchCountLabel.textColor = .gray5
    }
    
    private func setConstraints() {
        [plantImage, nameLabel, scientificNameLabel, searchCountLabel].forEach {
            contentView.addSubview($0)
        }
        
        plantImage.snp.makeConstraints {
            $0.width.equalTo(114)
            $0.height.equalTo(88)
            $0.left.top.equalTo(contentView).offset(10)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.top.equalTo(contentView).offset(18)
            $0.left.equalTo(plantImage.snp.right).offset(8)
        }
        
        scientificNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.equalTo(nameLabel)
        }
        
        searchCountLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.right.equalTo(contentView).offset(-12)
            $0.top.equalTo(contentView).offset(78)
        }
    }
}
