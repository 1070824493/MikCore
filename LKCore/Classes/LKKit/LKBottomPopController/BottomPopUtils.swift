//
//  BottomPopUtils.swift
//  LKMobile
//
//  Created by peng binfeng on 2021/1/29.
//

import UIKit

typealias BottomPresentableViewController = BottomPopupAttributesDelegate & UIViewController

public protocol BottomPopupDelegate: AnyObject {
    func bottomPopupViewLoaded()
    func bottomPopupWillAppear()
    func bottomPopupDidAppear()
    func bottomPopupWillDismiss()
    func bottomPopupDidDismiss()
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat)
}

public extension BottomPopupDelegate {
    func bottomPopupViewLoaded() { }
    func bottomPopupWillAppear() { }
    func bottomPopupDidAppear() { }
    func bottomPopupWillDismiss() { }
    func bottomPopupDidDismiss() { }
    func bottomPopupDismissInteractionPercentChanged(from oldValue: CGFloat, to newValue: CGFloat) { }
}

public protocol BottomPopupAttributesDelegate: AnyObject {
    var popupHeight: CGFloat { get }
    var popupTopCornerRadius: CGFloat { get }
    var popupPresentDuration: Double { get }
    var popupDismissDuration: Double { get }
    var popupShouldDismissInteractivelty: Bool { get }
    var popupDimmingViewAlpha: CGFloat { get }
    var popupShouldBeganDismiss: Bool { get }
    var popupViewAccessibilityIdentifier: String { get }
}

public struct BottomPopConstants {
    static let kDefaultHeight: CGFloat = UIScreen.lk.height - UIViewController.lk.safeAreaMin.top
    static let kDefaultTopCornerRadius: CGFloat = 16.0
    static let kDefaultPresentDuration = 0.25
    static let kDefaultDismissDuration = 0.25
    static let dismissInteractively = true
    static let shouldBeganDismiss = true
    static let kDimmingViewDefaultAlphaValue: CGFloat = 0.75
    static let defaultPopupViewAccessibilityIdentifier: String = "com.lk.bottomPopupView"
}
