//
//  MikNavigationController.swift
//  MikCore
//
//  Created by m7 on 2021/10/19.
//

import UIKit


fileprivate var kAnimationCompleteKey: Void?

public extension UINavigationController {
    
    typealias AnimationComplete = (UIViewController.Type) -> Void
    
    /// ‘Push’完成回调
    var mik_didShowAnimationComplete: AnimationComplete? {
        get { objc_getAssociatedObject(self, &kAnimationCompleteKey) as? AnimationComplete }
        set { objc_setAssociatedObject(self, &kAnimationCompleteKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
}

open class MikNavigationController: UINavigationController {
    
    private var navigationBarColor: UIColor = UIColor.mik.general(.hexFFFFFF) {
        didSet {
            guard navigationBarColor.mik.rgbaValue() != oldValue.mik.rgbaValue() else { return }
            self.navigationBar.setBackgroundColor(color: navigationBarColor)
        }
    }
    
    private var navitionShadowImageColor: UIColor = .clear {
        didSet {
            guard navitionShadowImageColor.mik.rgbaValue() != oldValue.mik.rgbaValue() else {
                return
            }
            
            if navitionShadowImageColor == .clear {
                self.navigationBar.setShadowImage(isHidden: true)
            }else {
                self.navigationBar.setShadowImage(isHidden: false, color: navitionShadowImageColor)
            }
        }
    }
    
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    public override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        defer {
            super.pushViewController(viewController, animated: animated)
            interactivePopGestureRecognizer?.isEnabled = true
        }
        viewController.hidesBottomBarWhenPushed = viewControllers.count > 0
        viewController.navigationItem.leftBarButtonItem = self.createBackButtonItem()
    }
    
}

// MARK: - Assistant
extension MikNavigationController {
    
    private func configure() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
        
        let config = UINavigationBarAppearance(barAppearance: navigationBar.standardAppearance)
        config.backgroundColor = UIColor.mik.general(.hexFFFFFF)
        config.shadowImage = UIImage()
        config.shadowColor = .clear
        config.titleTextAttributes = [.foregroundColor : UIColor.mik.general(.hex1B1B1B),
                                        .font: UIFont.mik.font(.IBMPlexSerifBold, size: 16.rate)]

        navigationBar.barStyle = UIBarStyle.default
        navigationBar.barTintColor = UIColor.mik.general(.hexFFFFFF)
        navigationBar.scrollEdgeAppearance = config
        navigationBar.standardAppearance = config
    }
    
}

// MARK: - Private
extension MikNavigationController {
    
    private func createBackButtonItem() -> UIBarButtonItem? {
        guard viewControllers.count > 0 else { return nil }
        
        let backButton = UIButton(type: .custom)
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel?.font = UIFont.mik.font(.IBMPlexSerifBold, size: 16.rate)
        backButton.setTitleColor(UIColor.mik.general(.hex1B1B1B), for: .normal)
        backButton.setImage(UIImage.image("nav_back"), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 14)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        backButton.addTarget(self, action:#selector(didClickOnBackButton(_:)), for: UIControl.Event.touchUpInside)
        return UIBarButtonItem(customView: backButton)
    }
    
}

// MARK: - SEL
@objc extension MikNavigationController {
    
    private func didClickOnBackButton(_ sender: UIButton) {
        if let backHandler = self.topViewController?.mik_backHandler {
            backHandler()
        }else {
            self.popViewController(animated: true)
        }
    }
    
}


// MARK: - UINavigationControllerDelegate
extension MikNavigationController: UINavigationControllerDelegate {
    
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.navigationBarColor = viewController.mik_navigationBarColor
        self.navitionShadowImageColor = viewController.mik_navigationShadowImageColor
    }
    
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        self.mik_didShowAnimationComplete?(type(of: viewController))
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension MikNavigationController: UIGestureRecognizerDelegate {
    
    // 侧滑返回手势开启条件
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && ( topViewController?.mik_swipeBackEnbaled ?? true)
    }
    
    // 解决滑动返回与其他手势冲突
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.interactivePopGestureRecognizer, self.topViewController?.mik_swipeBackEnbaled ?? true {
            otherGestureRecognizer.require(toFail: gestureRecognizer)
            return false
        }
        return true
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.interactivePopGestureRecognizer {
            return self.topViewController?.mik_swipeBackEnbaled ?? true
        }
        return true
    }
    
}
