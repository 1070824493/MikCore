//
//  LKBottomPopViewController.swift
//  LKMobile
//
//  Created by peng binfeng on 2021/1/29.
//

import UIKit

open class LKBottomPopViewController: LKBaseViewController, BottomPopupAttributesDelegate {

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
    
    
    open weak var popupDelegate: BottomPopupDelegate?
    private var transitionHandler: BottomPopupTransitionHandler?
    
    // MARK: Initializations
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        transitionHandler?.notifyViewLoaded(withPopupDelegate: popupDelegate)
        popupDelegate?.bottomPopupViewLoaded()
        self.view.accessibilityIdentifier = popupViewAccessibilityIdentifier
    }
    
    open override  func viewWillAppear(_ animated: Bool) {
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
