//
//  CommonAlertView.swift
//  CommonPlant
//
//  Created by 아라 on 11/30/23.
//

import UIKit
import SnapKit

class CommonAlertView: UIView {
    // MARK: UIComponents
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyB2
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    var messageLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyM3
        label.textColor = .gray6
        label.textAlignment = .center
        return label
    }()
    var buttonView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray2
        return view
    }()
    var cancleButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init("취소")
        attribute.font = .bodyM2
        config.attributedTitle = attribute
        config.baseForegroundColor = .gray5
        config.background.cornerRadius = 0
        button.configuration = config
        button.backgroundColor = .white
        return button
    }()
    var actionButton = UIButton()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.makeRound(radius: 14)
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    func setConstraints() {
        [titleLabel, messageLabel, buttonView].forEach {
            self.addSubview($0)
        }
        
        [cancleButton, actionButton].forEach {
            buttonView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(33)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(104)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
        
        cancleButton.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(43.5)
        }

        actionButton.snp.makeConstraints { make in
            make.leading.equalTo(cancleButton.snp.trailing).offset(1)
            make.trailing.bottom.equalToSuperview()
            make.width.equalTo(cancleButton.snp.width)
            make.height.equalTo(43.5)
        }
    }
    
    func setActionButton(title: String) {
        var config = UIButton.Configuration.plain()
        var attribute = AttributedString.init(title)
        attribute.font = .bodyB2
        config.attributedTitle = attribute
        config.baseForegroundColor = .seaGreenDark3
        config.background.cornerRadius = 0
        actionButton.configuration = config
        actionButton.backgroundColor = .white
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setMessage(_ message: String) {
        messageLabel.text = message
    }
}
