//
//  MainMyPlantCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/08.
//

import UIKit
import SnapKit

class MainMyPlantCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainMyPlantCollectionViewCell"
    let imageView = UIImageView()
    let plantNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }
    
    private func configureCell() {
        setAttributes(with: Plant.init(plantImage: "", plantName: ""))
        setConstraints()
    }
    
    // MARK: - UI
    func setAttributes(with plant: Plant) {
        imageView.image = UIImage(named: plant.plantImage)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        
        plantNameLabel.text = plant.plantName
        plantNameLabel.font = .bodyM3
    }
    
    private func setConstraints() {
        self.addSubview(imageView)
        self.addSubview(plantNameLabel)
        imageView.snp.makeConstraints {
            $0.left.top.right.equalToSuperview()
            $0.height.equalTo(164)
            $0.width.equalTo(108)
        }
        
        plantNameLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.left.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.bottom.equalToSuperview()
        }
    }
}

