//
//  FriendRequestTableViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 6/17/24.
//

import UIKit
import Then
import SnapKit

class FriendRequestTableViewCell: UITableViewCell {
    static let identifier = "FriendRequestTableViewCell"
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfileGray")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 40
    }
    private let nameLabel = UILabel().then {
        $0.font = .bodyB2
        $0.text = "이름"
    }
    private let placeNameLabel = UILabel().then {
        $0.font = .bodyB3
        $0.textColor = .gray6
        $0.text = "일이삼사오륙칠팔구십"
    }
    private let roadAddressLabel = UILabel().then {
        $0.font = .bodyM4
        $0.textColor = .gray5
        $0.text = "고무래로 35 반포리체 아파트"
        $0.lineBreakMode = .byTruncatingTail
    }
    private let confirmButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .bodyB3
        $0.layer.cornerRadius = 8
        
    }
    private let deleteButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.gray6, for: .normal)
        $0.titleLabel?.font = .bodyB3
        $0.layer.cornerRadius = 8
    }
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        confirmButton.backgroundColor = self.isHighlighted ? .seaGreenDark3 : .seaGreenDark2
        deleteButton.backgroundColor = self.isHighlighted ? .gray5 : .gray4
        stackView.addArrangedSubview(confirmButton)
        stackView.addArrangedSubview(deleteButton)
    }
    
    private func setConstraints() {
        [profileImageView, nameLabel, placeNameLabel, roadAddressLabel, stackView].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.width.height.equalTo(80)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.top.equalTo(profileImageView.snp.top)
            make.left.equalTo(profileImageView.snp.right).offset(14)
            make.right.equalToSuperview().offset(-20)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.width.greaterThanOrEqualTo(roadAddressLabel)
        }
        
        roadAddressLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.centerY.equalTo(placeNameLabel)
            make.left.equalTo(placeNameLabel.snp.right).offset(4)
            make.right.equalToSuperview().offset(-24)
        }
        
        stackView.snp.makeConstraints { make in
            make.height.equalTo(36)
            make.left.equalTo(nameLabel.snp.left)
            make.top.equalTo(placeNameLabel.snp.bottom).offset(8)
            make.right.equalToSuperview().offset(-20)
        }
    }
}
