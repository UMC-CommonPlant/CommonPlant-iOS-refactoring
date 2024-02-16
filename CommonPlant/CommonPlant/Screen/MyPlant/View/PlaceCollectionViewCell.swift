//
//  PlaceCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 2/7/24.
//

import UIKit
import SnapKit

class PlaceCollectionViewCell: UICollectionViewCell {
    static let identifier = "PlaceCollectionViewCell"
    
    private let placeImageView: UIImageView = {
        let view = UIImageView()
        view.makeRound(radius: 16)
        view.makeGradation()
        view.layer.opacity = 0.7
        return view
    }()
    private let placeNameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB2
        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    func setConfigure(with data: Place) {
        if let imgUrl = URL(string: data.placeImage) {
            placeImageView.load(url: imgUrl)
        } else {
            placeImageView.image = UIImage(named: "MyPlant")
        }
        placeNameLabel.text = data.placeName
    }
    
    func setConstraints() {
        [placeImageView, placeNameLabel].forEach {
            contentView.addSubview($0)
        }
        
        placeImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
