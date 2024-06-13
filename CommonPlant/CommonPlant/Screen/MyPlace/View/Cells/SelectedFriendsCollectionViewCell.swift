//
//  SelectedFriendsCollectionViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 6/11/24.
//

import UIKit
import Then
import SnapKit
import RxSwift

class SelectedFriendsCollectionViewCell: UICollectionViewCell {
    static let identifier = "SelectedFriendsCollectionViewCell"
    var disposeBag = DisposeBag()
    
    private let profileImageView = UIImageView().then {
        $0.layer.cornerRadius = 18
        $0.image = UIImage(named: "ProfileGray")
    }
    let deleteButton = UIButton().then {
        $0.setImage(UIImage(named: "Delete"), for: .normal)
        $0.layer.cornerRadius = 6
    }
    let nameLabel = UILabel().then {
        $0.font = .bodyM4
        $0.textColor = .gray4
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
        
        deleteButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview()
            make.height.width.equalTo(18)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(16)
            make.left.right.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom)
        }
    }
    
    func configure(with friend: String) {
        nameLabel.text = friend
    }
}
