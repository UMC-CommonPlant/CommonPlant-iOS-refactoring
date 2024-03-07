//
//  CalendarMemoCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit
import SnapKit

class CalendarMemoCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarMemoCollectionViewCell"
    
    private let userImageView: UIImageView = {
        let view = UIImageView()
        view.makeRound(radius: 16)
        return view
    }()
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM2
        label.textColor = .gray6
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .captionM2
        label.textColor = .gray4
        return label
    }()
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM2
        label.textColor = .gray6
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    let moreLabel: UILabel = {
        let label = UILabel()
        label.font = .captionM1
        label.textColor = .gray3
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.makeShadow()
        contentView.makeRound(radius: 10)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        userImageView.image = nil
        nicknameLabel.text = nil
        dateLabel.text = nil
        contentLabel.text = nil
    }
    
    func setConfigure(with data: CalendarMemo) {
        if let imgUrl = URL(string: data.userProfileImageString) {
            userImageView.load(url: imgUrl)
        } else {
            // TODO: 기본 이미지로
        }
        
        nicknameLabel.text = data.userNickname
        contentLabel.text = data.content
    }
    
    func setConstraints() {
        [userImageView, nicknameLabel, dateLabel, contentLabel, moreLabel].forEach {
            contentView.addSubview($0)
        }
        
        userImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(32)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.leading.equalTo(userImageView.snp.trailing).offset(8)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.trailing.equalToSuperview().inset(10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        moreLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(7)
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(6)
        }
    }
}
