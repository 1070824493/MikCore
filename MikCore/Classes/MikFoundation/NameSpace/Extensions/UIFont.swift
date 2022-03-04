//
//  UIFont.swift
//  EyeShield
//
//  Created by m7 on 2021/2/25.
//

import UIKit

public enum FontType {
    /// 常规体：body-large/regular、body-medium/regular、body-small/regular
    case `default`
    /// 常规体：body-large/regular、body-medium/regular、body-small/regular
    case nunitoSans
    /// 粗体：h4、h5、h6、body-large/bold、body-medium/bold、body-small/bold
    case nunitoSansBold
    /// 中粗体：body-large/semibold、body-medium/semibold、body-small/semibold
    case nunitoSansSemibold
    /// 特粗体：h4、h5、h6、body-large/bold、body-medium/bold、body-small/bold
    case nunitoSansExtraBold
    /// 细体
    case nunitoSansLight
    
    var fontName: String {
        switch self {
        case .default, .nunitoSans: return "NunitoSans-Regular"
        case .nunitoSansBold: return "NunitoSans-Bold"
        case .nunitoSansLight: return "NunitoSans-Light"
        case .nunitoSansSemibold: return "NunitoSans-SemiBold"
        case .nunitoSansExtraBold: return "NunitoSans-ExtraBold"
        }
    }
}

public extension MikNameSpace where Base: UIFont {
        
    /// 字体
    /// - Parameters:
    ///   - type: 字体类型
    ///   - size: 字体大小
    /// - Returns: 字体
    static func font(_ type: FontType = .default, size: CGFloat) -> UIFont {
        var font = UIFont(name: type.fontName, size: size)
        if font == nil {
            if UIFont.registerFontNamed(type.fontName) {
                font = UIFont(name: type.fontName, size: size)
            }
        }
        return font ?? UIFont.systemFont(ofSize: size)
    }
}
