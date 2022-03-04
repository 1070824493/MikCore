//
//  UIColor.swift
//  EyeShield
//
//  Created by m7 on 2021/2/25.
//

import UIKit

public extension MikNameSpace where Base: UIColor {
    
    typealias RGBAValueTuple = (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat)
    
    /// 根据 RGB 值生成颜色 eg: UIColor.mik.rgb(46, 169, 223, alpha: 1.0)
    static func rgb(_ red: Int, _ green: Int, _ blue: Int, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    /// 根据颜色的十六进制值即透明度构建颜色 eg: UIColor.mik.hex(hex: 0x24323A)
    /// - Parameters:
    ///   - hex: 颜色的16进制表示
    ///   - alpha: 透明度（0~1.0）
    /// - Returns: 根据颜色的十六进制值构建颜色
    static func hex(_ hex: Int, alpha: CGFloat = 1) -> UIColor {
        let red = (hex & 0xFF0000) >> 16
        let green = (hex & 0xFF00) >> 8
        let blue = hex & 0xFF
        return UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: alpha)
    }
    
    /// 获取‘RGBA’值
    /// - Returns: 颜色对应的‘RGBA’值
    func rgbaValue() -> RGBAValueTuple {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.base.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
}


// MARK: - 常用颜色
public extension MikNameSpace where Base: UIColor {
    
    /// 常用颜色
    enum HexColorsEnum: String, CaseIterable {
        case hex000000 = "#000000", hexFFFFFF = "#FFFFFF", hex1B1B1B = "#1B1B1B"
        case hex006A57 = "#006A57", hex0475BC = "#0475BC", hex00856D = "#00856D"
        case hex009783 = "#009783", hex757575 = "#757575", hexA85D00 = "#A85D00"
        case hexC5E4C8 = "#C5E4C8", hexCDCDCD = "#CDCDCD", hexCF1F2E = "#CF1F2E"
        case hexD1E8F8 = "#D1E8F8", hexEB003B = "#EB003B", hexEBAB33 = "#EBAB33"
        case hexECF6F4 = "#ECF6F4", hexED7064 = "#ED7064", hexEFF7FB = "#EFF7FB"
        case hexF2F2F2 = "#F2F2F2", hexF3F3F3 = "#F3F3F3", hexF8D2CB = "#F8D2CB"
        case hexFEF5F8 = "#FEF5F8", hexFFF2DF = "#FFF2DF", hex454545 = "#454545"
        case hexEAEAEA = "#EAEAEA", hexF6F6F6 = "#F6F6F6", hex909090 = "#909090"
        case hexAEAEAE = "#AEAEAE", hex5F5F5F = "#5F5F5F", hex303030 = "#303030"
        case hexF8F3EC = "#F8F3EC", hex7E84B7 = "#7E84B7", hexB10917 = "#B10917"
        case hexFFFFF0 = "#FFFFF0", hex808080 = "#808080", hexA9A9A9 = "#A9A9A9"
        case hexC0C0C0 = "#C0C0C0", hexD3D3D3 = "#D3D3D3", hex8B0000 = "#8B0000"
        case hexA52A2A = "#A52A2A", hexBC8F8F = "#BC8F8F", hexFF0000 = "#FF0000"
        case hexF08080 = "#F08080", hexFA8072 = "#FA8072", hexFF8C00 = "#FF8C00"
        case hexFF4500 = "#FF4500", hexFF6347 = "#FF6347", hexFFA500 = "#FFA500"
        case hexFF7F50 = "#FF7F50", hex51260B = "#51260B", hex995409 = "#995409"
        case hexC06600 = "#C06600", hexD2691E = "#D2691E", hexF4A460 = "#F4A460"
        case hexFFDAB9 = "#FFDAB9", hex808000 = "#808000", hexBDB76B = "#BDB76B"
        case hexF0E68C = "#F0E68C", hexFFD700 = "#FFD700", hexFFFF00 = "#FFFF00"
        case hexFFFFE0 = "#FFFFE0", hexF5F5DC = "#F5F5DC", hex006400 = "#006400"
        case hex008000 = "#008000", hex2E8B57 = "#2E8B57", hex90EE90 = "#90EE90"
        case hex008B8B = "#008B8B", hex20B2AA = "#20B2AA", hex00FFFF = "#00FFFF"
        case hexE1FFFF = "#E1FFFF", hex00008B = "#00008B", hex000080 = "#000080"
        case hex87CEFA = "#87CEFA", hex00BFFF = "#00BFFF", hex87CEEB = "#87CEEB"
        case hex4B0082 = "#4B0082", hex800080 = "#800080", hexEE82EE = "#EE82EE"
        case hexFFCAFF = "#FFCAFF", hexE9EAF2 = "#E9EAF2", hex4FB7AA = "#4FB7AA"
        case hexFF1493 = "#FF1493", hex024F7F = "#024F7F", hex2C3261 = "#2C3261"
        case hexBDE4DF = "#BDE4DF", hexFEF1EF = "#FEF1EF", hexF9E4BD = "#F9E4BD"
        case hexEBF5FC = "#EBF5FC", hexE9F5F3 = "#E9F5F3", hexFF69B4 = "#FF69B4"
        case hexFFC0CB = "#FFC0CB", hexFFB6C1 = "#FFB6C1", hex4C9DCF = "#4C9DCF"
        case hexBCAA95 = "#BCAA95", hexFBFBFB = "#FBFBFB"
    }
    
    /// 根据色值名称取颜色
    /// - Parameters:
    ///   - name: 颜色名称
    ///   - alpha: 透明度（0~1.0）
    /// - Returns: 颜色
    private static func name(_ name: String, alpha: CGFloat? = nil) -> UIColor {
        return UIColor { (trait) -> UIColor in
            if let alpha = alpha {
                return UIColor(named: name, in: Bundle.mik.default, compatibleWith: trait)!.withAlphaComponent(alpha)
            } else {
                return UIColor(named: name, in: Bundle.mik.default, compatibleWith: trait)!
            }
        }
    }
    
    /// 适用于字体颜色
    /// - Parameters:
    ///   - hexColor: 常用颜色
    ///   - alpha: 透明度（0~1.0）
    /// - Returns: 颜色
    static func text(_ hexColor: HexColorsEnum, alpha: CGFloat? = nil) -> UIColor {
        return Self.name(hexColor.rawValue, alpha: alpha)
    }
    
    /// 适用于视图颜色
    /// - Parameters:
    ///   - hexColor: 常用颜色
    ///   - alpha: 透明度（0~1.0）
    /// - Returns: 颜色
    static func general(_ hexColor: HexColorsEnum, alpha: CGFloat? = nil) -> UIColor {
        return Self.name(hexColor.rawValue, alpha: alpha)
    }
    
}
