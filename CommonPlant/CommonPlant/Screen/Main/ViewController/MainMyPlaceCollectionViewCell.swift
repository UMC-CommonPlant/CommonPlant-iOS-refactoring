//
//  MainMyPlaceCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 2023/07/07.
//

import UIKit
import SnapKit

class MainMyPlaceCollectionViewCell: UICollectionViewCell {
    static let identifier = "MainMyPlaceCollectionViewCell"
    let imageView = UIImageView()
    let gradientView = UIView()
    let placeLabel = UILabel()
    let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCell()
        self.layoutIfNeeded()
        setGradient()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCell()
        self.layoutIfNeeded()
        setGradient()
    }

    func configureCell() {
        setAttributes(with: Place.init(placeImage: "", placeName: ""))
        setConstraints()
        self.layoutIfNeeded()
        setGradient()
    }
    
    // MARK: - UI
    func setGradient() {
        gradientLayer.frame = gradientView.bounds
        let colors: [CGColor] = [
            UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor,
            UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
        ]
        gradientLayer.cornerRadius = 16
        gradientLayer.colors = colors
        gradientLayer.locations = [0, 0.67]
        gradientLayer.startPoint = CGPoint(x: 0.25, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.25, y: 0)
        gradientView.layer.addSublayer(gradientLayer)
    }
    
    func disableGradient() {
        gradientLayer.isHidden = true
    }
    
    func setAttributes(with place: Place) {
        imageView.image = UIImage(named: place.placeImage)
        imageView.layer.cornerRadius = 16
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        gradientView.backgroundColor = .clear
        gradientView.alpha = 0.7
        gradientView.layer.cornerRadius = 16
        
        placeLabel.text = place.placeName
        placeLabel.font = .bodyB2
        placeLabel.textColor = .white
    }
    
    private func setConstraints() {
        [imageView, gradientView, placeLabel].forEach {
            self.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(156)
            $0.width.equalTo(250)
        }
        
        gradientView.snp.makeConstraints {
            $0.edges.equalTo(imageView)
        }
        
        placeLabel.snp.makeConstraints {
            $0.height.equalTo(22)
            $0.left.equalTo(gradientView.snp.left).offset(15)
            $0.bottom.equalTo(gradientView.snp.bottom).offset(-10)
        }
    }
}
