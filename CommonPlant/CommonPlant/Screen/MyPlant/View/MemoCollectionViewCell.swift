//
//  MemoCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/27.
//

import UIKit
import SnapKit

class MemoCollectionViewCell: UICollectionViewCell {
    // MARK: Properties
    static let identifier = "MemoCollectionViewCell"
    
    // MARK: UI Components
    var memoCardView = UIView()
    let profileView = UIImageView()
    let nickNameLabel = UILabel()
    let contentLabel = UILabel()
    let dateLabel = UILabel()
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    // MARK: Custom Methods
    func setAttributes() {
        self.makeShadow()
        self.backgroundColor = .white
        
        memoCardView.makeRound(radius: 16)
        memoCardView.layer.borderWidth = 1
        memoCardView.layer.borderColor = UIColor.gray2?.cgColor
        
        profileView.makeRound(radius: 16)
        profileView.contentMode = .scaleAspectFill
        
        nickNameLabel.font = .bodyM2
        nickNameLabel.textColor = .gray6
        
        contentLabel.font = .bodyM2
        contentLabel.textColor = .gray6
        contentLabel.numberOfLines = 2
        
        imageView.makeRound(radius: 8)
        imageView.contentMode = .scaleAspectFill
        
        dateLabel.font = .captionM1
        dateLabel.textColor = .gray4
    }
    
    func setHierarchy() {
        self.addSubview(memoCardView)
        
        [profileView, nickNameLabel, contentLabel, imageView, dateLabel].forEach {
            memoCardView.addSubview($0)
        }
    }
    
    func setConstraints() {
        memoCardView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        profileView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileView.snp.trailing).offset(8)
            make.centerY.equalTo(profileView.snp.centerY)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(profileView.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(4)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(67.5)
            make.height.equalTo(54)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-20)
            make.trailing.equalToSuperview().offset(-25.5)
        }
    }
}
