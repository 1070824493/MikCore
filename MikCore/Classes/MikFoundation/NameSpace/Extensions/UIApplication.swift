//
//  UIApplication.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/8.
//

import UIKit


public extension MikNameSpace where Base: UIApplication {
    
    /// Sweeter: `keyWindow` for scene-based apps
    var legacyKeyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return self.base.windows.first { $0.isKeyWindow }
        } else {
            return self.base.keyWindow
        }
    }

    /// 当前控制器
    static func currentViewController(base: UIViewController? = UIApplication.shared.mik.legacyKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return currentViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        return base
    }
    
    /// 当前导航控制器
    static func currentNavigationController(base: UIViewController? = UIApplication.shared.mik.legacyKeyWindow?.rootViewController) -> UINavigationController? {
        let view = self.currentViewController(base: base)?.view
        var n = view?.next
        while n != nil {
            if n is UINavigationController { return n as? UINavigationController }
            n = n?.next
        }
        return nil
    }
    
    /// 拨打电话
    /// - Parameter telphone: 电话号码
    static func openPhoneCall(_ telphone: String?, result: ((Bool) -> Void)?) {
        let bPhone = telphone?.replacingOccurrences(of: "\\D", with: "", options: .regularExpression, range: nil)
        guard let bPhone = bPhone, !bPhone.isEmpty,
              let phoneURL = URL(string: "telprompt://" + bPhone),
                UIApplication.shared.canOpenURL(phoneURL) else {
                    result?(false)
                    return
                }
        UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        result?(true)
    }
    
}
