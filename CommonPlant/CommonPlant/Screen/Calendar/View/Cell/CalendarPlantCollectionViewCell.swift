//
//  CalendarPlantCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit
import SnapKit

class CalendarPlantCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarPlantCollectionViewCell"
    
    private let plantImageView: UIImageView = {
        let view = UIImageView()
        view.makeRound(radius: 10)
        return view
    }()
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM3
        label.textColor = .gray5
        label.textAlignment = .center
        return label
    }()
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM3
        label.textColor = .gray5
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeShadow()
        contentView.makeRound(radius: 8)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        plantImageView.image = nil
        nicknameLabel.text = nil
        nameLabel.text = nil
    }
    
    func setConfigure(whit data: CalendarPlant) {
        if let imgUrl = URL(string: data.imageString) {
            plantImageView.load(url: imgUrl)
        } else {
            // TODO: 기본 이미지로
        }
        
        nicknameLabel.text = data.nickname
        nameLabel.text = data.name
    }
    
    func setConstraints() {
        [plantImageView, nicknameLabel, nameLabel].forEach {
            contentView.addSubview($0)
        }
        
        plantImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.centerX.equalToSuperview()
            make.width.equalTo(83)
            make.height.equalTo(62)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(8)
        }
    }
}
