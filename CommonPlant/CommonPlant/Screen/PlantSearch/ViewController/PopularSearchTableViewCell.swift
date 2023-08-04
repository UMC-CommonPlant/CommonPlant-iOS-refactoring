//
//  PopularSearchTableViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/08/01.
//

import UIKit
import SnapKit

class PopularSearchTableViewCell: UITableViewCell {
    static let identifier = "PopularSearchTableViewCell"
    let plantImage = UIImageView()
    let nameLabel = UILabel()
    let scientificNameLabel = UILabel()
    let searchCountLabel = UILabel()
    let mainBackView = UIView()
    let shadowView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        setAttributes(with: PoplularSearchModel.init(plantImage: "", plantName: "", scientificName: "", searchCount: 0))
        setConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupCorner()
        mainBackView.layer.masksToBounds = true
        let radius = shadowView.layer.bounds
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: shadowView.layer.bounds, cornerRadius: 16).cgPath
        
    }
    
    // MARK: - UI
    private func setupCorner() {
        mainBackView.layer.cornerRadius = 16
      //  mainBackView.layer.masksToBounds = false
      //  mainBackView.clipsToBounds = false
        self.contentView.clipsToBounds = false
        self.mainBackView.backgroundColor = .white
        
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor(red: 0.471, green: 0.471, blue: 0.471, alpha: 0.25).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 4
        
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
        self.contentView.addSubview(shadowView)
        self.contentView.addSubview(mainBackView)
        
        [plantImage, nameLabel, scientificNameLabel, searchCountLabel].forEach {
            mainBackView.addSubview($0)
        }
        
        plantImage.snp.makeConstraints {
            $0.width.equalTo(114)
            $0.height.equalTo(88)
            $0.left.top.equalToSuperview().offset(10)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.top.equalToSuperview().offset(18)
            $0.left.equalTo(plantImage.snp.right).offset(8)
        }
        
        scientificNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(nameLabel.snp.bottom)
            $0.left.equalTo(nameLabel)
        }
        
        searchCountLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.right.equalToSuperview().offset(-12)
            $0.top.equalToSuperview().offset(78)
        }
        
        mainBackView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(108)
        }
        
        shadowView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(108)
        }
    }
}


import SwiftUI

struct Preview: PreviewProvider {
    static var previews: some View {
        MainTabBarController().toPreview()
    }
}
