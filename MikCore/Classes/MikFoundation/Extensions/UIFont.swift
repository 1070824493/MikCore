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
    /// 标题字体：hero、h1、h2
    case newYorkExtraBold
    /// 细体
    case nunitoSansLight
    
    /// weight: 700, 8月24新字体:所有nav/tabs/menu/header以及其他各种组件的标题/正文中的标题全部的字体改为：IBM Plex Serif Bold
    case IBMPlexSerifBold
    
    case IBMPlexSerifSemiBoldItalic
    case IBMPlexSerifBoldItalic
    case IBMPlexSerifExtraLight
    case IBMPlexSerifExtraLightItalic
    case IBMPlexSerifItalic
    case IBMPlexSerifLight
    case IBMPlexSerifLightItalic
    case IBMPlexSerifMedium
    case IBMPlexSerifMediumItalic
    case IBMPlexSerifRegular
    case IBMPlexSerifSemiBold
    case IBMPlexSerifText
    case IBMPlexSerifTextItalic
    case IBMPlexSerifThin
    case IBMPlexSerifThinItalic
    
    var fontName: String {
        switch self {
        case .default, .nunitoSans: return "NunitoSans-Regular"
        case .nunitoSansBold: return "NunitoSans-Bold"
        case .nunitoSansLight: return "NunitoSans-Light"
        case .nunitoSansSemibold: return "NunitoSans-SemiBold"
        case .nunitoSansExtraBold: return "NunitoSans-ExtraBold"
        
        case .newYorkExtraBold: return "NewYork-Bold"
            
        case .IBMPlexSerifBold: return "IBMPlexSerif-Bold"
        case .IBMPlexSerifSemiBoldItalic: return "IBMPlexSerif-SemiBoldItalic"
        case .IBMPlexSerifBoldItalic: return "IBMPlexSerif-BoldItalic"
        case .IBMPlexSerifExtraLight: return "IBMPlexSerif-ExtraLight"
        case .IBMPlexSerifExtraLightItalic: return "IBMPlexSerif-ExtraLightItalic"
        case .IBMPlexSerifItalic: return "IBMPlexSerif-Italic"
        case .IBMPlexSerifLight: return "IBMPlexSerif-Light"
        case .IBMPlexSerifLightItalic: return "IBMPlexSerif-LightItalic"
        case .IBMPlexSerifMedium: return "IBMPlexSerif-Medium"
        case .IBMPlexSerifMediumItalic: return "IBMPlexSerif-MediumItalic"
        case .IBMPlexSerifRegular: return "IBMPlexSerif-Regular"
        case .IBMPlexSerifSemiBold: return "IBMPlexSerif-SemiBold"
        case .IBMPlexSerifText: return "IBMPlexSerif-Text"
        case .IBMPlexSerifTextItalic: return "IBMPlexSerif-TextItalic"
        case .IBMPlexSerifThin: return "IBMPlexSerif-Thin"
        case .IBMPlexSerifThinItalic: return "IBMPlexSerif-ThinItalic"
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
