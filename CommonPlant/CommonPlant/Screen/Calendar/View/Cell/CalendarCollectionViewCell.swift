//
//  CalendarCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 3/6/24.
//

import UIKit
import SnapKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM2
        label.textColor = .gray6
        label.textAlignment = .center
        return label
    }()
    let selectedView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreen
        view.makeRound(radius: 20)
        view.isHidden = true
        return view
    }()
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .equalSpacing
        return view
    }()
    let firstMetView: UIView = {
        let view = UIView()
        view.backgroundColor = .sunflowerYellow
        view.makeRound(radius: 2)
        view.isHidden = true
        return view
    }()
    let waterView: UIView = {
        let view = UIView()
        view.backgroundColor = .aquaBlue
        view.makeRound(radius: 2)
        view.isHidden = true
        return view
    }()
    let memoView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreenLight
        view.makeRound(radius: 2)
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(\(coder) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = nil
    }
    
    func setConstraints() {
        [selectedView, dayLabel].forEach {
            contentView.addSubview($0)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectedView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().inset(1)
            make.width.height.equalTo(40)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(selectedView.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
            make.height.equalTo(4)
        }
    }
}
