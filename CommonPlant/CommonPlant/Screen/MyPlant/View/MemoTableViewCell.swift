//
//  MomoTableViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/29.
//

import UIKit
import SnapKit

class MemoTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "MomoTableViewCell"
    
    // MARK: - UI Components
    var profileImageView = UIImageView()
    var nickNameLabel = UILabel()
    var moreButton = UIButton()
    var postImageView = UIImageView()
    var contentLabel = UILabel()
    var dateLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    // MARK: - Custom Methods
    func setAttributes() {
        self.backgroundColor = .white
        
        var moreBtnConfig = UIButton.Configuration.plain()
        
        profileImageView.makeRound(radius: 16)
        profileImageView.contentMode = .scaleAspectFill
        
        nickNameLabel.font = .bodyM2
        nickNameLabel.textColor = .gray6
        
        moreBtnConfig.image = UIImage(named: "More")
        moreButton.configuration = moreBtnConfig
        
        postImageView.makeRound(radius: 8)
        postImageView.contentMode = .scaleAspectFill
        
        contentLabel.font = .bodyM2
        contentLabel.textColor = .gray6
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        
        dateLabel.font = .captionM1
        dateLabel.textColor = .gray4
    }
    
    func setHierarchy() {
        [profileImageView, nickNameLabel, moreButton, postImageView, contentLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.width.height.equalTo(32)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(profileImageView.snp.trailing).offset(8)
            make.centerY.equalTo(profileImageView.snp.centerY)
        }
        
        moreButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalTo(profileImageView.snp.centerY)
            make.width.height.equalTo(28)
        }
        
        postImageView.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(242)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.trailing.equalTo(-20)
        }
    }
}
