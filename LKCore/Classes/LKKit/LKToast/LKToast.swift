//
//  LKToast.swift
//  LKCore
//
//  Created by m7 on 2021/4/21.
//

import UIKit

public extension LKToast {
    
    public struct HUDConifgure {
        let view: UIView?
        var style: LKHUDStyle = .activity
        var isInteraction: Bool = false
        
        public init(view: UIView?, style: LKHUDStyle = .activity, isInteraction: Bool = false) {
            self.view = view
            self.style = style
            self.isInteraction = isInteraction
        }
    }
    
    public static func showHUD(configure: HUDConifgure) {
        Self.showHUD(style: configure.style, in: configure.view, isInteraction: configure.isInteraction)
    }
    
}


public class LKToast {
    
    /// HUD styles
    public enum LKHUDStyle: Equatable {
        case activity, logo, message(String?)
        
        public static func == (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
            case (.activity, .activity): return true
            case (.logo, .logo): return true
            case (.message(let lText), .message(let rText)): return lText == rText
            default: return false
            }
        }
    }
    
    /// Toast styles
    public enum LKToastStyle {
        case information(title: String?, message: String?), success(title: String?, message: String?), warn(title: String?, message: String?), error(title: String?, message: String?)
    }
    
    /// Toast action
    public struct LKToastAction {
        public typealias LKToastActionHandler = () -> Void
        
        let title: String
        let actionHandler: LKToastActionHandler
        
        public init(title: String, actionHandler: @escaping LKToastActionHandler) {
            self.title = title
            self.actionHandler = actionHandler
        }
    }
    
    /// Config Toast
    public static func configToastStyle() {
        ToastManager.shared.style.activityBackgroundColor = .clear
        ToastManager.shared.style.activitySize = CGSize(width: min(80.rate, 80), height: min(80.rate, 80))
        ToastManager.shared.style.activityIndicatorColor = UIColor.lk.color(.hex1B1B1B)
        ToastManager.shared.style.verticalPadding = UIViewController.lk.safeAreaMax.bottom + 16
        
        ToastManager.shared.isTapToDismissEnabled = false
        ToastManager.shared.isQueueEnabled = false
        ToastManager.shared.duration = 3
        ToastManager.shared.position = .bottom
    }
    
    /// Show HUD
    /// - Parameters:
    ///   - style: HUD style
    ///   - view: HUD's superview
    ///   - isInteraction: Whether user interaction
    public static func showHUD(style: LKHUDStyle = .activity, in view: UIView?, isInteraction: Bool = false) {
        guard let view = view else { return }
        
        let oldHudView = view.activityView as? LKBaseHUDView
                
        guard oldHudView?.style != style else { return }
        
        let hud: UIView? = {
            switch style {
            case .activity: return LKActivityHUDView(frame: view.bounds)
            case .logo: return LKLogoHUDView(frame: view.bounds)
            case .message(let msg):
                switch oldHudView?.style {
                case .message(_):
                    oldHudView?.style = .message(msg)
                    return nil
                default: return LKMessageHUDView(frame: view.bounds, message: msg)
                }
            }
        }()
                
        hud?.isUserInteractionEnabled = isInteraction
        
        guard let hudView = hud else { return }
                
        guard let _ = oldHudView else {
            DispatchQueue.main.async { view.makeToastActivity(hudView, .center) }
            return
        }        
        
        DispatchQueue.main.async {
            // Hide current HUD
            view.hideToastActivity(animation: false)
            // Show HUD
            view.makeToastActivity(hudView, .center, false)
        }
    }
    
    
    /// Show toast on view, default is window
    /// - Parameters:
    ///   - view: The toast's superview
    ///   - style: The toast's style
    ///   - duration: diaplay time
    ///   - action: action
    public static func showToast(in view: UIView? = UIApplication.shared.windows.last,
                                 style: LKToastStyle,
                                 duration: TimeInterval = 3,
                                 action: LKToastAction? = nil) {
        guard let view = view, let customView = LKDefaultToastView(style: style, action: action) else { return }
        customView.frame = CGRect(origin: .zero, size: customView.systemLayoutSizeFitting(UIScreen.main.bounds.size))
        view.showToast(customView, duration: duration, position: .bottom, completion: nil)
    }
    
    /// Hides all HUD in view.
    public static func hideHUD(in view: UIView?) {
        DispatchQueue.main.async { view?.hideToastActivity(animation: false) }
    }

}
