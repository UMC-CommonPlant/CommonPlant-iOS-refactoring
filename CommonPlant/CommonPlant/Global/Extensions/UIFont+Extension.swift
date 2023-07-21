//
//  UIFont+Extension.swift
//  CommonPlant
//
//  Created by 아라 on 2023/07/06.
//

import UIKit

extension UIFont {
    public enum fontType: String{
        case bold = "Bold"
        case medium = "Medium"
    }
    
    static func AppleSDGothicNeo(_ type: fontType, size: CGFloat) -> UIFont {
        return UIFont(name: "AppleSDGothicNeo-\(type.rawValue)", size: size)!
    }
}

extension UIFont {
    // HeadLine
    class var head1: UIFont { AppleSDGothicNeo(.bold, size: 40.0) }
    class var head2: UIFont { AppleSDGothicNeo(.bold, size: 36.0) }
    class var head3: UIFont { AppleSDGothicNeo(.bold, size: 32.0) }
    class var head4: UIFont { AppleSDGothicNeo(.bold, size: 28.0) }
    class var head5: UIFont { AppleSDGothicNeo(.bold, size: 24.0) }
    class var head6: UIFont { AppleSDGothicNeo(.bold, size: 20.0) }
    
    // Body
    class var bodyB1: UIFont { AppleSDGothicNeo(.bold, size: 18.0) }
    class var bodyM1: UIFont { AppleSDGothicNeo(.medium, size: 18.0) }
    class var bodyB2: UIFont { AppleSDGothicNeo(.bold, size: 16.0) }
    class var bodyM2: UIFont { AppleSDGothicNeo(.medium, size: 16.0) }
    class var bodyB3: UIFont { AppleSDGothicNeo(.bold, size: 14.0) }
    class var bodyM3: UIFont { AppleSDGothicNeo(.medium, size: 14.0) }
    class var bodyB4: UIFont { AppleSDGothicNeo(.bold, size: 12.0) }
    class var bodyM4: UIFont { AppleSDGothicNeo(.medium, size: 12.0) }
    
    // Caption
    class var captionB1: UIFont { AppleSDGothicNeo(.bold, size: 14.0) }
    class var captionM1: UIFont { AppleSDGothicNeo(.medium, size: 14.0) }
    class var captionB2: UIFont { AppleSDGothicNeo(.bold, size: 12.0) }
    class var captionM2: UIFont { AppleSDGothicNeo(.medium, size: 12.0) }
}
