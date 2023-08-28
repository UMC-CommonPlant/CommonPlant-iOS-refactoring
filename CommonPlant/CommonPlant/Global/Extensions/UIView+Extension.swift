//
//  UIView+Extension.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/08.
//

import UIKit

extension UIView {
    func makeRound(radius: CGFloat){
        layer.cornerRadius = radius
        clipsToBounds = true
    }
    
    func makeShadow() {
        layer.shadowColor = UIColor.gray5?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
        layer.cornerRadius = 16
    }
}
