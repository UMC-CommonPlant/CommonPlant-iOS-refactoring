//
//  CommonCTAButton.swift
//  CommonPlant
//
//  Created by 이예원 on 1/17/24.
//

import UIKit
enum ButtonSize {
    case large, mid, small
}

enum ButtonColor {
    case green, gray
}


final class CommonCTAButton: UIButton {
    private var buttonSize: ButtonSize
    private var buttonColor: ButtonColor
    
    var text: String? {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    
    var isDisabled: Bool = true {
        didSet {
            self.isEnabled = !isDisabled
            updateBackgroundColorForState()
        }
    }
    
    
    init(size: ButtonSize, color: ButtonColor) {
        self.buttonSize = size
        self.buttonColor = color
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        switch buttonSize {
        case .large:
            self.titleLabel?.font = .bodyM2
            self.layer.cornerRadius = 8
        case .mid, .small:
            self.titleLabel?.font = buttonSize == .mid ? .captionM1 : .bodyM3
            self.layer.cornerRadius = 4
        }
        
        setTitleColor(.white, for: .normal)
        setTitleColor(.white, for: .highlighted)
        setTitleColor(.gray3, for: .disabled)
        
        updateBackgroundColorForState()
        setConstraints()
    }
    
    private func updateBackgroundColorForState() {
        var backgroundColor: UIColor = .gray1!
        
        if isDisabled {
            backgroundColor = .gray1!
        } else if isHighlighted {
            backgroundColor = buttonColor == .green ? .seaGreenDark3! : .gray6!
        } else {
            backgroundColor = buttonColor == .green ? .seaGreenDark1! : .gray5!
        }
        
        self.backgroundColor = backgroundColor
    }
    
    private func setConstraints() {
        self.snp.makeConstraints {
            switch buttonSize {
            case .large:
                $0.height.equalTo(48)
            case .mid:
                $0.height.equalTo(40)
            case .small:
                $0.height.equalTo(32)
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            updateBackgroundColorForState()
        }
    }
}
