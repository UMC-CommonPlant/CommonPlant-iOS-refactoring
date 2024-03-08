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
    private let nicknameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM2
        label.textColor = .gray6
        return label
    }()
    private let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM2
        label.textColor = .gray6
        label.numberOfLines = 3
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    private let nextImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Next")
        return view
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
        contentLabel.text = nil
        nextImageView.image = nil
    }
    
    func setConfigure(with data: CalendarMemo) {
        if let imgUrl = URL(string: data.userProfileImageString) {
            userImageView.load(url: imgUrl)
        } else {
            // TODO: 기본 이미지로
        }
        
        nicknameLabel.text = data.userNickname
        contentLabel.text = data.content
        contentLabel.sizeToFit()
        self.layoutIfNeeded()
    }
    
    func setConstraints() {
        [userImageView, nicknameLabel, nextImageView, contentLabel].forEach {
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
        
        nextImageView.snp.makeConstraints { make in
            make.centerY.equalTo(userImageView.snp.centerY)
            make.trailing.equalToSuperview()
            make.width.height.equalTo(48)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(nextImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(4)
        }
    }
}
