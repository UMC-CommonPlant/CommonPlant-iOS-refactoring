//
//  UILabel+Extension.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/09.
//

import UIKit

extension UILabel {
    func partiallyChanged(targetString: String, font: UIFont?, color: UIColor?) {
        let fullText = text ?? ""
        let attributedString = NSMutableAttributedString(string: fullText)
        let range = (fullText as NSString).range(of: targetString)
        attributedString.addAttributes([.font: font as Any, .foregroundColor: color as Any], range: range)
        attributedText = attributedString
    }
}
