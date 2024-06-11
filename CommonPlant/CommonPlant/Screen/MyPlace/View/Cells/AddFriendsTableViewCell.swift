//
//  AddFriendsTableViewCell.swift
//  CommonPlant
//
//  Created by 이예원 on 6/10/24.
//

import UIKit
import Then
import SnapKit
import RxCocoa
import RxSwift

class AddFriendsTableViewCell: UITableViewCell {
    static let identifier = "AddFriendsTableViewCell"
    private let disposeBag = DisposeBag()
    
    private let profileImageView = UIImageView().then {
        $0.image = UIImage(named: "ProfileGray")
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 20
    }
    private let nameLabel = UILabel().then {
        $0.font = .bodyM2
        $0.textColor = .gray6
        $0.text = "이름"
    }
    private let checkImage = UIButton().then {
        $0.setImage(UIImage(named: "CheckEmpty"), for: .normal)
        $0.setImage(UIImage(named: "SelectedGreen"), for: .selected)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupBindings()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupBindings() {
        checkImage.rx.tap
            .bind { [weak self] in
                guard let self = self else { return }
                self.checkImage.isSelected.toggle()
            }
            .disposed(by: disposeBag)
    }
    
    private func setConstraints() {
        [profileImageView, nameLabel, checkImage].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.height.width.equalTo(40)
            make.left.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { make in
            make.height.equalTo(22)
            make.left.equalTo(profileImageView.snp.right).offset(16)
            make.centerY.equalToSuperview()
            make.right.equalTo(checkImage.snp.left).offset(-14)
        }
        
        checkImage.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-20)
        }
    }
}
