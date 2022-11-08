//
//  UIColorExtension.swift
//  crypto_app
//
//  Created by Petru-Alexandru Lipici on 07.11.2022.
//

import UIKit

extension UIColor {
    struct Text {
        static let primary = UIColor.fromRGB(rgbValue: 0x2E333C)
        static let secondary = UIColor.fromRGB(rgbValue: 0x6C7076)
        static let deselected = UIColor.fromRGB(rgbValue: 0xC0C1C4)
    }
    
    class func fromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
