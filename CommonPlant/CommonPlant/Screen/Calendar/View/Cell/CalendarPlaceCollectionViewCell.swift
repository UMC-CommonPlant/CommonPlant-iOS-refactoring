//
//  PlantCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit
import SnapKit

class CalendarPlaceCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarPlaceCollectionViewCell"
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderColor = UIColor.seaGreenDark2?.cgColor
        view.layer.borderWidth = 1
        view.makeRound(radius: 8)
        return view
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM3
        label.textColor = .seaGreenDark2
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.makeRound(radius: 8)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
    }
    
    func setConfigure(whit data: CalendarPlace) {
        titleLabel.text = data.title
    }
    
    func setConstraints() {
        [borderView, titleLabel].forEach {
            contentView.addSubview($0)
        }
        
        borderView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(12)
        }
    }
}
