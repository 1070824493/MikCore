//
//  MikBottomPopNavigationController.swift
//  MikMobile
//
//  Created by peng binfeng on 2021/1/29.
//

import UIKit
import SnapKit

open class MikBottomPopNavigationController: MikNavigationController, BottomPopupAttributesDelegate {
    
    // MARK: - 弹窗时属性设置
    public var height: CGFloat?
    public var topCornerRadius: CGFloat?
    public var presentDuration: Double?
    public var dismissDuration: Double?
    public var shouldDismissInteractivelty: Bool?
    public var dimmingViewAlpha: CGFloat?
    
    // MARK: - BottomPopAttributesDelegate Variables
    open var popupHeight: CGFloat { return height ??  BottomPopConstants.kDefaultHeight }
    
    open var popupTopCornerRadius: CGFloat { return topCornerRadius ?? BottomPopConstants.kDefaultTopCornerRadius }
    
    open var popupPresentDuration: Double { return presentDuration ?? BottomPopConstants.kDefaultPresentDuration }
    
    open var popupDismissDuration: Double { return dismissDuration ?? BottomPopConstants.kDefaultDismissDuration }
    
    open var popupShouldDismissInteractivelty: Bool { return shouldDismissInteractivelty ?? BottomPopConstants.dismissInteractively }
    
    open var popupDimmingViewAlpha: CGFloat { return dimmingViewAlpha ?? BottomPopConstants.kDimmingViewDefaultAlphaValue }
    
    open var popupShouldBeganDismiss: Bool { BottomPopConstants.shouldBeganDismiss }
    
    open var popupViewAccessibilityIdentifier: String { BottomPopConstants.defaultPopupViewAccessibilityIdentifier }
    
    public var leftTitle: String? {
        didSet {
            if let barButtonItem = topViewController?.navigationItem.leftBarButtonItem {
                if let label = barButtonItem.customView as? UILabel {
                    label.text = leftTitle
                } else if let btn = barButtonItem.customView as? UIButton {
                    btn.setTitle(leftTitle, for: .normal)
                }
            }
        }
    }
    
// MARK: -
    private var transitionHandler: BottomPopupTransitionHandler?
    open weak var popupDelegate: BottomPopupDelegate?
    
    // MARK: Initializations
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
        
        initialize()
        
        rootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: self.createTitleLab())
        self.addRightBarButtonItem(title: nil, image: UIImage.image("nav_del"))
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.barStyle = UIBarStyle.default
        self.navigationBar.barTintColor = UIColor.white
        
        transitionHandler?.notifyViewLoaded(withPopupDelegate: popupDelegate)
        popupDelegate?.bottomPopupViewLoaded()
        self.view.accessibilityIdentifier = popupViewAccessibilityIdentifier
        
        self.navigationBar.isTranslucent = false
    }

    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        curveTopCorners()
        popupDelegate?.bottomPopupWillAppear()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        popupDelegate?.bottomPopupDidAppear()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        popupDelegate?.bottomPopupWillDismiss()
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        popupDelegate?.bottomPopupDidDismiss()
    }
    
    //MARK: Private Methods
    
    private func initialize() {
        transitionHandler = BottomPopupTransitionHandler(popupViewController: self)
        transitioningDelegate = transitionHandler
        modalPresentationStyle = .custom
    }
    
    private func curveTopCorners() {
        let path = UIBezierPath(roundedRect: self.view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: popupTopCornerRadius, height: popupTopCornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.view.bounds
        maskLayer.path = path.cgPath
        self.view.layer.mask = maskLayer
    }
}

extension MikBottomPopNavigationController {
    
    private func createTitleLab() -> UILabel {
        let label = UILabel()
        label.font = UIFont.mik.font(.IBMPlexSerifBold, size: 16.rate)
        label.textColor = UIColor.mik.text(.hex1B1B1B)
        label.textAlignment = .left
        return label
    }
    
}

// MARK: - 添加导航右侧按钮
extension MikBottomPopNavigationController {
    
    public func addRightBarButtonItem(title: String?, font: UIFont = UIFont.mik.font(.nunitoSansBold, size: 14.rate), textColor: UIColor = UIColor.mik.text(.hex0475BC), image: UIImage?) {
        if let controller = self.topViewController {
            let rightButton = UIButton.init(type: .custom)
            if let theTitle = title {
                rightButton.titleLabel?.font = font
                rightButton.setTitleColor(textColor, for: .normal)
                rightButton.setTitle(theTitle, for: .normal)
            } else if let img = image {
                rightButton.setImage(img, for: .normal)
            }
            rightButton.addTarget(self, action: #selector(closeButtonAction), for: UIControl.Event.touchUpInside)
            controller.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
        }
    }
    @objc private func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

