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
    
    func makeShadow(cornerRadius: CGFloat) {
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowColor = UIColor.gray5?.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 2
    }
    
    func makeGradation() {
        self.layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 250, height: 156)
        let colors: [CGColor] = [
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0).cgColor,
            UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0).cgColor
        ]
        gradientLayer.colors = colors
        gradientLayer.locations = [0.3, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        
        self.layer.addSublayer(gradientLayer)
    }
}
