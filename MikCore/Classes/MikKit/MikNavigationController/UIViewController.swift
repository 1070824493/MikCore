//
//  UIViewController.swift
//  MikCore
//
//  Created by m7 on 2021/10/19.
//

import UIKit


fileprivate var kNavigationBarBackgroundColorKey: Void?
fileprivate var kNavigationBarShadowImageColorKey: Void?
fileprivate var kNavigationSwipeBackEnbaledKey: Void?
fileprivate var kNavigationBackHandlerKey: Void?


public extension UIViewController {
    
    typealias NavigationBackHandler = () -> Void
    
    
    /// ‘NavigationBar‘颜色
    var mik_navigationBarColor: UIColor {
        get { objc_getAssociatedObject(self, &kNavigationBarBackgroundColorKey) as? UIColor ?? UIColor.mik.general(.hexFFFFFF) }
        set { objc_setAssociatedObject(self, &kNavigationBarBackgroundColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// ’NavigationBar‘分割线颜色
    var mik_navigationShadowImageColor: UIColor {
        get { objc_getAssociatedObject(self, &kNavigationBarShadowImageColorKey) as? UIColor ?? .clear }
        set { objc_setAssociatedObject(self, &kNavigationBarShadowImageColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    /// 是否允许侧滑返回
    var mik_swipeBackEnbaled: Bool {
        get { return objc_getAssociatedObject(self, &kNavigationSwipeBackEnbaledKey) as? Bool ?? true }
        set { objc_setAssociatedObject(self, &kNavigationSwipeBackEnbaledKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    /// ’backButtonItem‘回调事件
    var mik_backHandler: NavigationBackHandler? {
        get { objc_getAssociatedObject(self, &kNavigationBackHandlerKey) as? NavigationBackHandler }
        set { objc_setAssociatedObject(self, &kNavigationBackHandlerKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
}
