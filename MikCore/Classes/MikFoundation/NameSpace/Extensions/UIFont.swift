//
//  UIFont.swift
//  EyeShield
//
//  Created by m7 on 2021/2/25.
//

import UIKit

public enum FontType: CaseIterable {
    
    case `default`
    
    case newYorkRegular, newYorkExtraBold
    
    case nunitoSans, nunitoSansBold, nunitoSansSemibold, nunitoSansExtraBold, nunitoSansLight
    
    case IBMPlexSerifBold, IBMPlexSerifSemiBoldItalic, IBMPlexSerifBoldItalic, IBMPlexSerifExtraLight,
         IBMPlexSerifExtraLightItalic, IBMPlexSerifItalic, IBMPlexSerifLight, IBMPlexSerifLightItalic,
         IBMPlexSerifMedium, IBMPlexSerifMediumItalic, IBMPlexSerifRegular, IBMPlexSerifSemiBold,
         IBMPlexSerifText, IBMPlexSerifTextItalic, IBMPlexSerifThin, IBMPlexSerifThinItalic
    
    case InterBlack, InterBlackItalic, InterBold, InterBoldItalic, InterExtraBold, InterExtraBoldItalic, InterExtraLight, InterExtraLightItalic, InterItalic, InterLight, InterLightItalic, InterMedium, InterMediumItalic, InterRegular, InterSemiBold, InterSemiBoldItalic, InterThin, InterThinItalic
    
}

fileprivate extension FontType {
    
    typealias FileSource = (name: String, type: String)
    
    var source: FileSource? {
        switch self {
        case .InterBlack: return ("Inter-Black", "ttf")
        case .InterBlackItalic: return ("Inter-BlackItalic", "ttf")
        case .InterBold: return ("Inter-Bold", "ttf")
        case .InterBoldItalic: return ("Inter-BoldItalic", "ttf")
        case .InterExtraBold: return ("Inter-ExtraBold", "ttf")
        case .InterExtraBoldItalic: return ("Inter-ExtraBoldItalic", "ttf")
        case .InterExtraLight: return ("Inter-ExtraLight", "ttf")
        case .InterExtraLightItalic: return ("Inter-ExtraLightItalic", "ttf")
        case .InterItalic: return ("Inter-Italic", "ttf")
        case .InterLight: return ("Inter-Light", "ttf")
        case .InterLightItalic: return ("Inter-LightItalic", "ttf")
        case .InterMedium: return ("Inter-Medium", "ttf")
        case .InterMediumItalic: return ("Inter-MediumItalic", "ttf")
        case .InterRegular: return ("Inter-Regular", "ttf")
        case .InterSemiBold: return ("Inter-SemiBold", "ttf")
        case .InterSemiBoldItalic: return ("Inter-SemiBoldItalic", "ttf")
        case .InterThin: return ("Inter-Thin", "ttf")
        case .InterThinItalic: return ("Inter-ThinItalic", "ttf")
        default: return nil
        }
    }
    
    var fontName: String {
        switch self {
        case .default, .nunitoSans: return "Inter-Regular"
        case .nunitoSansBold: return "Inter-Bold"
        case .nunitoSansLight: return "Inter-Light"
        case .nunitoSansSemibold: return "Inter-SemiBold"
        case .nunitoSansExtraBold: return "Inter-ExtraBold"
            
        case .newYorkRegular: return "Inter-Regular"
        case .newYorkExtraBold: return "Inter-ExtraBold"
        
        case .IBMPlexSerifBold: return "Inter-Bold"
        case .IBMPlexSerifBoldItalic: return "Inter-BoldItalic"
        case .IBMPlexSerifExtraLight: return "Inter-ExtraLight"
        case .IBMPlexSerifExtraLightItalic: return "Inter-ExtraLightItalic"
        case .IBMPlexSerifItalic: return "Inter-Italic"
        case .IBMPlexSerifLight: return "Inter-Light"
        case .IBMPlexSerifLightItalic: return "Inter-LightItalic"
        case .IBMPlexSerifMedium: return "Inter-Medium"
        case .IBMPlexSerifMediumItalic: return "Inter-MediumItalic"
        case .IBMPlexSerifRegular: return "Inter-Regular"
        case .IBMPlexSerifSemiBold: return "Inter-SemiBold"
        case .IBMPlexSerifSemiBoldItalic: return "Inter-SemiBoldItalic"
        case .IBMPlexSerifText: return "Inter-Regular"
        case .IBMPlexSerifTextItalic: return "Inter-Italic"
        case .IBMPlexSerifThin: return "Inter-Thin"
        case .IBMPlexSerifThinItalic: return "Inter-ThinItalic"
            
        case .InterBlack: return "Inter-Black"
        case .InterBlackItalic: return "Inter-BlackItalic"
        case .InterBold: return "Inter-Bold"
        case .InterBoldItalic: return "Inter-BoldItalic"
        case .InterExtraBold: return "Inter-ExtraBold"
        case .InterExtraBoldItalic: return "Inter-ExtraBoldItalic"
        case .InterExtraLight: return "Inter-ExtraLight"
        case .InterExtraLightItalic: return "Inter-ExtraLightItalic"
        case .InterItalic: return "Inter-Italic"
        case .InterLight: return "Inter-Light"
        case .InterLightItalic: return "Inter-LightItalic"
        case .InterMedium: return "Inter-Medium"
        case .InterMediumItalic: return "Inter-MediumItalic"
        case .InterRegular: return "Inter-Regular"
        case .InterSemiBold: return "Inter-SemiBold"
        case .InterSemiBoldItalic: return "Inter-SemiBoldItalic"
        case .InterThin: return "Inter-Thin"
        case .InterThinItalic: return "Inter-ThinItalic"
        }
    }
    
}

public extension MikNameSpace where Base: UIFont {
    
    /// 注册字体
    static func registerCustomFonts(types: [FontType] = FontType.allCases) {
        let fontUrls = types.compactMap({ type -> URL? in
            guard let source = type.source else { return nil }
            return Bundle.mik.default.url(forResource: source.name, withExtension: source.type)
        })
        
        guard !fontUrls.isEmpty else { return }
        
        CTFontManagerRegisterFontURLs(fontUrls as CFArray, .process, true, nil)
    }
    
    /// 字体
    /// - Parameters:
    ///   - type: 字体类型
    ///   - size: 字体大小
    /// - Returns: 字体
    static func font(_ type: FontType = .default, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: type.fontName, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
    
    /// 获取字体地址
    /// - Parameter type: 字体类型
    /// - Returns: 字体地址
    static func familyURL(type: FontType) -> URL? {
        return Bundle.mik.default.url(forResource: type.source?.name, withExtension: type.source?.type)
    }
    
}
