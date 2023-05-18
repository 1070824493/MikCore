//
//  LKNavigationController.swift
//  LKCore
//
//  Created by m7 on 2021/10/19.
//

import UIKit

private var kAnimationCompleteKey: Void?

// 'iOS 14.0'、'iOS 14.1' Pop回根视图后不显示‘TabBar’
private let isErrorVision: Bool = {
    guard let _ = ["14.0", "14.1"].first(where: {
        UIDevice.current.systemVersion.hasPrefix($0)
    }) else {
        return false
    }
    return true
}()

public extension LKNavigationController {
    typealias AnimationComplete = (UIViewController.Type) -> Void

    /// ‘Push’完成回调
    var lk_didShowAnimationComplete: AnimationComplete? {
        get { objc_getAssociatedObject(self, &kAnimationCompleteKey) as? AnimationComplete }
        set { objc_setAssociatedObject(self, &kAnimationCompleteKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }

    /// 此方法传入的控制器push时会隐藏底部tabbar:
    /// params eg: ["AddressesViewController"]
    static func appendWhiteList(_ controllers: [UIViewController.Type]) {
        self.hidesBottomBarWhenPushedList.append(contentsOf: controllers)
    }

    static func appendAutoHiddenTabbarWhiteList(_ controllers: [UIViewController.Type]) {
        self.autoHiddenTabbarWhenScrollList.append(contentsOf: controllers)
    }
}

open class LKNavigationController: UINavigationController {
    fileprivate static var hidesBottomBarWhenPushedList: [UIViewController.Type] = []

    fileprivate static var autoHiddenTabbarWhenScrollList: [UIViewController.Type] = []

    fileprivate var scrollViewUtil: LKNavigationScrollUtil?

    private var navigationBarColor = UIColor.lk.general(.hexFFFFFF) {
        didSet {
            guard navigationBarColor.lk.rgbaValue() != oldValue.lk.rgbaValue() else { return }
            self.navigationBar.setBackgroundColor(color: navigationBarColor)
        }
    }

    private var navitionShadowImageColor: UIColor = .clear {
        didSet {
            guard navitionShadowImageColor.lk.rgbaValue() != oldValue.lk.rgbaValue() else {
                return
            }

            if navitionShadowImageColor == .clear {
                self.navigationBar.setShadowImage(isHidden: true)
            } else {
                self.navigationBar.setShadowImage(isHidden: false, color: navitionShadowImageColor)
            }
        }
    }

    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return self.topViewController?.preferredStatusBarStyle ?? .default
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override public func pushViewController(_ viewController: UIViewController, animated: Bool) {
        defer {
            super.pushViewController(viewController, animated: animated)
            interactivePopGestureRecognizer?.isEnabled = true
        }

        viewController.hidesBottomBarWhenPushed = {
            let configHide = Self.hidesBottomBarWhenPushedList.contains(where: { type(of: viewController) == $0 })
            
            switch viewControllers.count {
            case 0:
                // 根视图
                return false
                
            case 1:
                return configHide

            default:
                return viewControllers.last?.hidesBottomBarWhenPushed == true ? !isErrorVision : configHide
            }
        }()

        viewController.navigationItem.leftBarButtonItem = self.createBackButtonItem()
    }
    
}

// MARK: - Assistant

extension LKNavigationController {
    private func configure() {
        delegate = self
        interactivePopGestureRecognizer?.delegate = self

        let config = UINavigationBarAppearance(barAppearance: navigationBar.standardAppearance)
        config.backgroundColor = UIColor.lk.general(.hexFFFFFF)
        config.shadowImage = UIImage()
        config.shadowColor = .clear
        config.titleTextAttributes = [.foregroundColor: UIColor.lk.general(.hex1B1B1B),
                                      .font: UIFont.lk.font(.IBMPlexSerifBold, size: 16)]

        navigationBar.barStyle = UIBarStyle.default
        navigationBar.barTintColor = UIColor.lk.general(.hexFFFFFF)
        navigationBar.scrollEdgeAppearance = config
        navigationBar.standardAppearance = config
    }
}

// MARK: - Private

extension LKNavigationController {
    private func createBackButtonItem() -> UIBarButtonItem? {
        guard viewControllers.count > 0 else { return nil }

        let backButton = UIButton(type: .custom)
        backButton.contentHorizontalAlignment = .left
        backButton.titleLabel?.font = UIFont.lk.font(.IBMPlexSerifBold, size: 16.rate)
        backButton.setTitleColor(UIColor.lk.general(.hex1B1B1B), for: .normal)
        backButton.setImage(UIImage.image("nav_back"), for: .normal)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 10, left: 4, bottom: 10, right: 14)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 4)
        backButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: -4)
        backButton.addTarget(self, action: #selector(didClickOnBackButton(_:)), for: UIControl.Event.touchUpInside)
        return UIBarButtonItem(customView: backButton)
    }
}

// MARK: - SEL

@objc extension LKNavigationController {
    private func didClickOnBackButton(_ sender: UIButton) {
        if let backHandler = self.topViewController?.lk_backHandler {
            backHandler()
        } else {
            self.popViewController(animated: true)
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension LKNavigationController: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        scrollViewUtil?.updateTabbarHiddenStatus(isHidden: false)
        // release vc
        scrollViewUtil = nil

        self.navigationBarColor = viewController.lk_navigationBarColor
        self.navitionShadowImageColor = viewController.lk_navigationShadowImageColor
    }

    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if LKNavigationController.autoHiddenTabbarWhenScrollList.contains(where: {
            type(of: viewController) == $0
        }) {
            scrollViewUtil = LKNavigationScrollUtil(viewController: viewController)
        }
        self.lk_didShowAnimationComplete?(type(of: viewController))
    }
}

// MARK: - UIGestureRecognizerDelegate

extension LKNavigationController: UIGestureRecognizerDelegate {
    // 侧滑返回手势开启条件
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1 && (topViewController?.lk_swipeBackEnbaled ?? true)
    }

    // 解决滑动返回与其他手势冲突
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.interactivePopGestureRecognizer, self.topViewController?.lk_swipeBackEnbaled ?? true {
            otherGestureRecognizer.require(toFail: gestureRecognizer)
            return false
        }
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer === self.interactivePopGestureRecognizer {
            return self.topViewController?.lk_swipeBackEnbaled ?? true
        }
        return true
    }
}
