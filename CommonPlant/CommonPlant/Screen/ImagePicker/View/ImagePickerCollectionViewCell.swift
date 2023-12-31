//
//  ImagePickerCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/19.
//

import UIKit

class ImagePickerCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImagePickerCollectionViewCell"
    
    // MARK: UIComponents
    var imageView = UIImageView()
    
    // MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConfigure()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    // MARK: Custom Methods
    func setConfigure() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
    func setConstraint() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
