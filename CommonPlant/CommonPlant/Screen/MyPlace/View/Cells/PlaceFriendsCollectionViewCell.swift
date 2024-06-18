//
//  PlaceFriendsCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 4/17/24.
//

import UIKit
import Then
import SnapKit

class PlaceFriendsCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "PlaceFriendsCollectionViewCell"
    
    // MARK: - UI Components
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 18
        $0.image = UIImage(named: "ProfileGray")
    }
    private let crownImageView = UIImageView().then {
        $0.image = UIImage(named: "Crown")
        $0.backgroundColor = .clear
    }
    private let nameLabel = UILabel().then {
        $0.font = .bodyM4
        $0.textColor = .gray4
    }
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    // MARK: - Custom Method
    private func setConstraints() {
        [profileImageView, crownImageView, nameLabel].forEach {
            self.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalToSuperview().offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.width.equalTo(36)
        }
        
        nameLabel.snp.makeConstraints {
            $0.height.equalTo(16)
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(profileImageView.snp.bottom)
        }
        
        crownImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(5)
            $0.width.height.equalTo(20)
        }
    }
}
