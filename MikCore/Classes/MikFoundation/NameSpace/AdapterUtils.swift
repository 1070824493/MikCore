//
//  AdapterUtils.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

//  注：此文件存放适配所用数据，其它东西勿放入

import Foundation
import UIKit

// MARK: - UIDevice

public extension MikNameSpace where Base: UIDevice {
    
    /// 是否全面屏
    /// eg: UIDevice.mik.isFullScreen
    static var isFullScreen: Bool {
        guard #available(iOS 11.0, *) else {
            return false
        }
        return UIApplication.shared.mik.legacyKeyWindow?.safeAreaInsets.bottom != 0
    }
    
}


// MARK: - UIWindow
public extension MikNameSpace where Base: UIWindow {
        
    /// 状态栏高度
    static var statusBarHeight: CGFloat {
        let statusBarManager = UIApplication.shared.mik.legacyKeyWindow?.windowScene?.statusBarManager
        return statusBarManager?.statusBarFrame.size.height ?? 0
    }
        
    /// HomeBar高度
    static var homeBarHeight: CGFloat {
        return UIApplication.shared.mik.legacyKeyWindow?.safeAreaInsets.bottom ?? 0
    }
    
}


// MARK: - UIViewController

public extension MikNameSpace where Base: UIViewController {
        
    /// StatuBar和HomeBar
    /// eg: StatuBar的高度: UIViewController.mik.safeAreaMin.top
    /// eg: HomeBar的高度: UIViewController.mik.safeAreaMin.bottom
    static var safeAreaMin: UIEdgeInsets {
        return UIEdgeInsets(top: UIWindow.mik.statusBarHeight, left: 0, bottom: UIWindow.mik.homeBarHeight, right: 0)
    }
    
    /// 导航栏高度和标签栏高度
    /// eg: 导航栏高度: UIViewController.mik.safeAreaMin.top
    /// eg: 标签栏高度: UIViewController.mik.safeAreaMin.bottom
    static var safeAreaMax: UIEdgeInsets {
        return UIEdgeInsets(top: UIWindow.mik.statusBarHeight + 44, left: 0, bottom: UIWindow.mik.homeBarHeight + 49, right: 0)
    }
    
    /// 安全区
    /// eg: UIViewController().mik.safeArea
    var safeArea: UIEdgeInsets {
        return self.base.view.mik.safeAreas()
    }
    
}


// MARK: - UIView

public extension MikNameSpace where Base: UIView {
    
    /// 安全区
    /// eg: UIView().mik.safeAreas()
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



