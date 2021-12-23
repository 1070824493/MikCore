//
//  CurrentBundle.swift
//  MikCore
//
//  Created by gaowei on 2021/4/28.
//

import UIKit


public extension UIImage {
        
    static func image(_ name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.mik.default, compatibleWith: nil)
    }
    
}

extension UIFont {
        
    /// 注册字体
    static func registerFontNamed(_ name: String) -> Bool {
        guard let fontURL = Bundle.mik.default.url(forResource: name, withExtension: "ttf") ?? Bundle.mik.default.url(forResource: name, withExtension: "otf") else { return false }
//        guard let fontDataProvider = CGDataProvider(url: fontURL as CFURL) else {
//            return false
//        }
        
//        guard let font = CGFont(fontDataProvider) else {
//            return false
//        }
        
        var error: Unmanaged<CFError>?
//        let success = CTFontManagerRegisterGraphicsFont(font, &error)
        let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .none, &error)
        guard success else {
            return false
        }
        
        return true
    }
    
}
