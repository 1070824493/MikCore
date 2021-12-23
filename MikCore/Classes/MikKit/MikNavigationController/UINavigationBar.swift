//
//  UINavigationBar.swift
//  MikCore
//
//  Created by m7 on 2021/10/19.
//

import UIKit


internal extension UINavigationBar {
    
    /// 设置navbar分割线
    /// - Parameters:
    ///   - isHidden: 是否隐藏
    ///   - color: 分割线颜色
    func setShadowImage(isHidden: Bool, color: UIColor? = nil) {
        let navConfig: UINavigationBarAppearance = self.scrollEdgeAppearance ?? self.standardAppearance
        navConfig.shadowImage = {
            if isHidden {
                return UIImage()
            }else {
                return UIImage.mik.image(color ?? UIColor.mik.general(.hexEAEAEA), size: CGSize(width: 1, height: 1))
            }
        }()
        self.scrollEdgeAppearance = navConfig
        self.standardAppearance = navConfig
    }
        
    /// 设置导航栏背景颜色
    /// - Parameter color: 导航栏背景颜色
    func setBackgroundColor(color: UIColor) {
        let navConfig: UINavigationBarAppearance = self.scrollEdgeAppearance ?? self.standardAppearance
        navConfig.backgroundColor = color
        self.scrollEdgeAppearance = navConfig
        self.standardAppearance = navConfig
    }
        
}
