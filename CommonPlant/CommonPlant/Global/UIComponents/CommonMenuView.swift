//
//  CommonMenuView.swift
//  CommonPlant
//
//  Created by 아라 on 2023/09/24.
//

import UIKit
import SnapKit

class CommonMenuView: UIView {
    // MARK: - UIComponents
    var editView = UIView()
    var editLabel = UILabel()
    var editImageView = UIImageView()
    var deleteView = UIView()
    var deleteLabel = UILabel()
    var deleteImageView = UIImageView()
    var divisionView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setHierarchy()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setAttributes() {
        self.backgroundColor = .white
        self.makeRound(radius: 16)
        
        editLabel.text = "수정하기"
        editLabel.font = .bodyM2
        editLabel.textColor = .black
        
        editImageView.image = UIImage(named: "Pen")
        
        deleteLabel.text = "삭제하기"
        deleteLabel.font = .bodyM2
        deleteLabel.textColor = .black
        
        deleteImageView.image = UIImage(named: "Trash")
        
        divisionView.backgroundColor = .gray1
    }
    
    func setHierarchy() {
        [editView, divisionView, deleteView].forEach {
            self.addSubview($0)
        }
        
        [editLabel, editImageView].forEach {
            editView.addSubview($0)
        }
        
        [deleteLabel, deleteImageView].forEach {
            deleteView.addSubview($0)
        }
    }
    
    func setConstraints() {
        self.snp.makeConstraints { make in
            make.width.equalTo(228)
            make.height.equalTo(128)
        }
        
        editView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(63.75)
        }
        
        editImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        editLabel.snp.makeConstraints { make in
            make.centerY.equalTo(editImageView.snp.centerY)
            make.leading.equalTo(editImageView.snp.trailing).offset(8)
            make.height.equalTo(32)
        }
        
        divisionView.snp.makeConstraints { make in
            make.top.equalTo(editView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        deleteView.snp.makeConstraints { make in
            make.top.equalTo(divisionView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(63.75)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        deleteLabel.snp.makeConstraints { make in
            make.centerY.equalTo(deleteImageView.snp.centerY)
            make.leading.equalTo(deleteImageView.snp.trailing).offset(8)
            make.height.equalTo(32)
        }
    }
}
