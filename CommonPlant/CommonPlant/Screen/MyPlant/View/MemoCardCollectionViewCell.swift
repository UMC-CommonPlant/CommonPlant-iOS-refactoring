//
//  MomoTableViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 2023/08/29.
//

import UIKit
import SnapKit
import Kingfisher

class MemoCardCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "MemoCardCollectionViewCell"
    
    // MARK: - UI Components
    var profileImageView = UIImageView()
    var nickNameLabel = UILabel()
    var moreButton = UIButton()
    var postImageView = UIImageView()
    var contentLabel = UILabel()
    var dateLabel = UILabel()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    // MARK: - Custom Methods
    func setAttributes(with model: Memo) {
        self.backgroundColor = .white
        var moreBtnConfig = UIButton.Configuration.plain()
        
        if let profileImageURL = URL(string: model.userImgURL) {
            profileImageView.load(url: profileImageURL) {
                
            }
            profileImageView.makeRound(radius: 16)
            profileImageView.contentMode = .scaleAspectFit
        }
        
        nickNameLabel.text = model.userNickName
        nickNameLabel.font = .bodyM2
        nickNameLabel.textColor = .gray6
        
        moreBtnConfig.image = UIImage(named: "More")
        moreButton.configuration = moreBtnConfig
        
        postImageView.makeRound(radius: 8)
        postImageView.contentMode = .scaleAspectFit
        
        if let postImageString = model.imgURL {
            if let postImageURL = URL(string: postImageString) {
                postImageView.kf.setImage(with: postImageURL) { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let value):
                        DispatchQueue.main.async {
                            let image = value.image
                            let aspectRatio = image.size.width / image.size.height
                            let width = self.contentView.frame.width - 40
                            self.postImageView.snp.remakeConstraints { make in
                                make.top.equalTo(self.profileImageView.snp.bottom).offset(16)
                                make.leading.equalToSuperview().offset(20)
                                make.trailing.equalToSuperview().offset(-20)
                                make.height.equalTo(width / aspectRatio)
                            }
                            
                            if let collectionView = self.superview as? UICollectionView {
                                collectionView.collectionViewLayout.invalidateLayout()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        } else {
            postImageView.image = nil
            postImageView.snp.remakeConstraints { make in  // 이미지 URL이 nil인 경우 이미지 뷰의 높이를 0으로 설정
                make.top.equalTo(profileImageView.snp.bottom).offset(16)
                make.leading.equalToSuperview().offset(20)
                make.trailing.equalToSuperview().offset(-20)
                make.height.equalTo(0)
            }
        }

        
        contentLabel.text = model.content
        contentLabel.font = .bodyM2
        contentLabel.textColor = .gray6
        contentLabel.numberOfLines = 0
        contentLabel.lineBreakMode = .byCharWrapping
        
        dateLabel.text = model.createdAt
        dateLabel.font = .captionM1
        dateLabel.textColor = .gray4
    }
    
    func setHierarchy() {
        [profileImageView, nickNameLabel, moreButton, postImageView, contentLabel, dateLabel].forEach {
            contentView.addSubview($0)
        }
    }
    
    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.leading.equalTo(contentView).offset(20)
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
            make.height.equalTo(0)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(postImageView.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-44)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(8)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-16)
        }
    }
}
