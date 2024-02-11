//
//  CalendarCollectionViewCell.swift
//  CommonPlant
//
//  Created by 아라 on 2/7/24.
//

import UIKit

class DatePickerCollectionViewCell: UICollectionViewCell {
    static let identifier = "DatePickerCollectionViewCell"
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM2
        label.textAlignment = .center
        return label
    }()
    let circleView: UIView = {
        let view = UIView()
        view.backgroundColor = .seaGreenDark1
        view.makeRound(radius: 20)
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
    
    func setConfigure(with day: String, isSelected: Bool, isToday: Bool) {
        dayLabel.text = day
        dayLabel.textColor = isSelected ? .gray2 : isToday ? .seaGreenDark2 : .black
        
        circleView.isHidden = !isSelected
    }
    
    func setConstraints() {
        [circleView, dayLabel].forEach {
            contentView.addSubview($0)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        circleView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
    }
}
