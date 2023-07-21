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
}
