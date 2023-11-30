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
    var titleLabel = UILabel()
    var messageLabel = UILabel()
    var buttonView = UIView()
    var cancleButton = UIButton()
    var agreeButton = UIButton()
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAttributes()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Custom Methods
    func setAttributes() {
        
    }
    
    func setConstraints() {
        
    }
    
    func setTitle(_ title: String) {
        
    }
    
    func setMessage(_ message: String) {
        
    }
    
    func setButtonTitle(_ title: String) {
        
    }
}
