//
//  AdapterUtils.swift
//  LKCore
//
//  Created by m7 on 2021/4/25.
//

//  注：此文件存放适配所用数据，其它东西勿放入

import Foundation
import UIKit

// MARK: - UIDevice

public extension LKNameSpace where Base: UIDevice {
    
    /// 是否全面屏
    /// eg: UIDevice.lk.isFullScreen
    static var isFullScreen: Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.lk.legacyKeyWindow?.safeAreaInsets.bottom != 0
    }
    
}


// MARK: - UIWindow
public extension LKNameSpace where Base: UIWindow {
        
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        let statusBarManager = UIApplication.shared.lk.legacyKeyWindow?.windowScene?.statusBarManager
        return statusBarManager?.statusBarFrame.size.height ?? 0
    }
        
    /// HomeBar高度
    static var homeBarHeight: CGFloat {
        return UIApplication.shared.lk.legacyKeyWindow?.safeAreaInsets.bottom ?? 0
    }
    
}


// MARK: - UIViewController

public extension LKNameSpace where Base: UIViewController {
        
    /// StatuBar和HomeBar
    /// eg: StatuBar的高度: UIViewController.lk.safeAreaMin.top
    /// eg: HomeBar的高度: UIViewController.lk.safeAreaMin.bottom
    static var safeAreaMin: UIEdgeInsets {
        return UIEdgeInsets(top: UIWindow.lk.statusBarHeight, left: 0, bottom: UIWindow.lk.homeBarHeight, right: 0)
    }
    
    /// 包含导航栏高度和标签栏高度(静态方法,始终包含导航栏/标签栏高度)
    /// eg: 导航栏高度: UIViewController.lk.safeAreaMax.top
    /// eg: 标签栏高度: UIViewController.lk.safeAreaMax.bottom
    static var safeAreaMax: UIEdgeInsets {
        return UIEdgeInsets(top: UIWindow.lk.statusBarHeight + 44, left: 0, bottom: UIWindow.lk.homeBarHeight + 49, right: 0)
    }

    /// 返回当前实例导航栏高度和标签栏高度(隐藏时不包含)
    /// eg: 导航栏高度: self.lk.safeAreaMax.top
    /// eg: 标签栏高度: self.lk.safeAreaMax.bottom
    var safeAreaMax: UIEdgeInsets {
        return UIEdgeInsets(
            top: UIWindow.lk.statusBarHeight + self.base.view.lk.safeAreas().top,
            left: self.base.view.lk.safeAreas().left,
            bottom: self.base.tabBarController?.tabBar.isHidden == true
            ? self.base.view.lk.safeAreas().bottom
            : self.base.view.lk.safeAreas().bottom + (self.base.tabBarController?.tabBar.bounds.height ?? 0),
            right: self.base.view.lk.safeAreas().right
        )
    }
    
    /// 安全区
    /// eg: UIViewController().lk.safeArea
    var safeArea: UIEdgeInsets {
        return self.base.view.lk.safeAreas()
    }
    
}


// MARK: - UIView

public extension LKNameSpace where Base: UIView {
    
    /// 安全区
    /// eg: UIView().lk.safeAreas()
    func safeAreas() -> UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.base.safeAreaInsets
        }
        return .zero
    }
    
}


// MARK: - BinaryFloatingPoint

public extension BinaryFloatingPoint {
    
    /// 屏幕宽度比
    /// eg: 320.rate, 320.0.rate
    var rate: CGFloat {
        let kRate = Float(UIScreen.main.bounds.width) / 375
        let kScale = Float(UIScreen.main.scale)
        return CGFloat(ceilf(Float(self) * kRate * kScale) / kScale)
    }
    
    /// 屏幕高度比
    var hRate: CGFloat {
        let kRate = Float(UIScreen.main.bounds.height) / 812
        let kScale = Float(UIScreen.main.scale)
        return CGFloat(ceilf(Float(self) * kRate * kScale) / kScale)
    }
    
}

// MARK: - BinaryInteger

public extension BinaryInteger {
    
    /// 屏幕宽度比
    var rate: CGFloat { Float(self).rate }
    
    /// 屏幕高度比
    var hRate: CGFloat { Float(self).hRate }
    
}


// MARK: - CGFloat

public extension CGFloat {
    
    /// 像素点大小
    /// eg: CGFloat.pixel
    static var pixel: CGFloat { return 1 / UIScreen.main.scale }
    
}



