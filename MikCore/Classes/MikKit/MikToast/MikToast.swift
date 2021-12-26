//
//  MikToast.swift
//  MikCore
//
//  Created by m7 on 2021/4/21.
//

import UIKit

public extension MikToast {
    
    struct HUDConifgure {
        let view: UIView?
        var style: MikHUDStyle = .activity
        var isInteraction: Bool = false
        
        public init(view: UIView?, style: MikHUDStyle = .activity, isInteraction: Bool = false) {
            self.view = view
            self.style = style
            self.isInteraction = isInteraction
        }
    }
    
    static func showHUD(configure: HUDConifgure) {
        Self.showHUD(style: configure.style, in: configure.view, isInteraction: configure.isInteraction)
    }
    
}

public class MikToast {
    
    /// HUD styles
    public enum MikHUDStyle: Equatable {
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
    public enum MikToastStyle {
        case information(title: String?, message: String?), success(title: String?, message: String?), warn(title: String?, message: String?), error(title: String?, message: String?)
    }
    
    /// Toast action
    public struct MikToastAction {
        public typealias MikToastActionHandler = () -> Void
        
        let title: String
        let actionHandler: MikToastActionHandler
        
        public init(title: String, actionHandler: @escaping MikToastActionHandler) {
            self.title = title
            self.actionHandler = actionHandler
        }
    }
    
    /// Config Toast
    public static func configToastStyle() {
        ToastManager.shared.style.activityBackgroundColor = .clear
        ToastManager.shared.style.activitySize = CGSize(width: min(80.rate, 80), height: min(80.rate, 80))
        ToastManager.shared.style.activityIndicatorColor = UIColor.mik.general(.hex1B1B1B)
        ToastManager.shared.style.verticalPadding = UIViewController.mik.safeAreaMax.bottom + 16
        
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
    public static func showHUD(style: MikHUDStyle = .activity, in view: UIView?, isInteraction: Bool = false) {
        guard let view = view else { return }
        
        let oldHudView = view.activityView as? MikBaseHUDView
                
        guard oldHudView?.style != style else { return }
        
        let hud: UIView? = {
            switch style {
            case .activity: return MikActivityHUDView(frame: view.bounds)
            case .logo: return MikLogoHUDView(frame: view.bounds)
            case .message(let msg):
                switch oldHudView?.style {
                case .message(_):
                    oldHudView?.style = .message(msg)
                    return nil
                default: return MikMessageHUDView(frame: view.bounds, message: msg)
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
            // Show HUD delay
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
                                 style: MikToastStyle,
                                 duration: TimeInterval = 3,
                                 action: MikToastAction? = nil) {
        guard let view = view, let customView = MikDefaultToastView(style: style, action: action) else { return }
        customView.frame = CGRect(origin: .zero, size: customView.systemLayoutSizeFitting(UIScreen.main.bounds.size))
        view.showToast(customView, duration: duration, position: .bottom, completion: nil)
    }
    
    /// Hides all HUD in view.
    public static func hideHUD(in view: UIView?) {
        DispatchQueue.main.async { view?.hideToastActivity() }
    }

}
