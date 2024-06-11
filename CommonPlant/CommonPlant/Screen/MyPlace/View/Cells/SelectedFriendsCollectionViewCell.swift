//
//  SelectedFriendsCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 6/11/24.
//

import UIKit
import Then
import SnapKit

class SelectedFriendsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectedFriendsCollectionViewCell"
    
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 18
        $0.image = UIImage(named: "ProfileGray")
    }
    private let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Delete"), for: .normal)
        $0.layer.cornerRadius = 6
    }
    private let nameLabel = UILabel().then {
        $0.text = "이름입니다"
        $0.font = .bodyM4
        $0.textColor = .gray4
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    private func setConstraints() {
        [profileImageView, deleteButton, nameLabel].forEach {
            self.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(5)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(18)
            
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom)
        }
    }
}
