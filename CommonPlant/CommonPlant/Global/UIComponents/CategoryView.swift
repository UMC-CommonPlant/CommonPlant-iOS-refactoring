//
//  CategoryView.swift
//  CommonPlant
//
//  Created by 이예원 on 7/14/24.
//

import Foundation
import UIKit
import SnapKit
import Then

struct CategoryModel {
    let label: String
    let color: String
    let icon: String
}

class CategoryView: UIView {
    private let button = UIButton().then {
        $0.layer.cornerRadius = 8
    }
    private let label = UILabel().then {
        $0.textAlignment = .center
        $0.font = .bodyM3
    }
    
    init(category: CategoryModel) {
        super.init(frame: .zero)
        setupView(category: category)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(category: CategoryModel) {
        addSubview(button)
        addSubview(label)
        
        button.backgroundColor = UIColor(named: category.color)
        button.setImage(UIImage(named: "OneRoom"), for: .normal)
        label.text = category.label
        
        button.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(56)
        }
        
        label.snp.makeConstraints { make in
            make.top.equalTo(button.snp.bottom)
            make.height.equalTo(20)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
