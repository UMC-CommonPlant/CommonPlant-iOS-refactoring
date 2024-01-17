//
//  SearchResultTableViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/08/08.
//

import UIKit

class SearchResultTableViewCell: UITableViewCell {
    static let identifier = "SearchResultTableViewCell"
    let plantImage = UIImageView()
    let nameLabel = UILabel()
    let scientificNameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           configureCell()
       }

   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func configureCell() {
        setAttributes(with: SearchResultModel(plantImage: "", plantName: "", scientificName: ""))
        setConstraints()
    }
    
    // MARK: - UI
    func setAttributes(with model: SearchResultModel) {
        plantImage.layer.cornerRadius = 16
        plantImage.image = UIImage(named: model.plantImage)
        plantImage.clipsToBounds = true
        plantImage.contentMode = .scaleAspectFill
        
        nameLabel.font = .bodyB2
        nameLabel.text = model.plantName
        
        scientificNameLabel.font = .bodyM4
        scientificNameLabel.text = model.scientificName
    }

    private func setConstraints() {
        [plantImage, nameLabel, scientificNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        plantImage.snp.makeConstraints {
            $0.width.equalTo(90)
            $0.height.equalTo(72)
            $0.top.equalTo(contentView).offset(10)
            $0.left.equalTo(contentView).offset(20)
            $0.bottom.equalTo(contentView).offset(-10)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.top.equalTo(contentView).offset(23)
            $0.left.equalTo(plantImage.snp.right).offset(16)
        }
        
        scientificNameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8)
            $0.left.equalTo(nameLabel)
        }
    }
}
