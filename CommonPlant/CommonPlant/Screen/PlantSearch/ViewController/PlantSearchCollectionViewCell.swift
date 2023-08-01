//
//  PlantSearchCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/31.
//

import UIKit
import SnapKit

class PlantSearchCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlantSearchCollectionViewCell"
    
    let background = UIView()
    let icon = UIImageView()
    let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
    }
    
    private func configureCell() {
        setAttributes()
        setConstraints()
    }
    
    // MARK: - UI
    func setAttributes() {
        background.backgroundColor = UIColor(red: 0.85, green: 0.79, blue: 0.96, alpha: 0.2)
        background.layer.cornerRadius = 8
        
        
        icon.image = UIImage(named: "Sunlight")
        
        label.text = "햇빛"
        label.font = .bodyM3
    }
    
    private func setConstraints() {
        [background, label].forEach {
            self.addSubview($0)
        }
        
        background.addSubview(icon)
        
        background.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
        }
 
        icon.snp.makeConstraints {
            $0.height.width.equalTo(24)
            $0.center.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(background.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
}
