//
//  LKDescPopoverView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit
import SnapKit
import ActiveLabel

public extension LKDescPopoverView {
    
    /// 显示描述的浮窗
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - displayArrow: 是否显示倒三角
    ///   - attributedMessage: 描述信息
    ///   - activeKeys: 超链接
    ///   - fromView: 锚点试图
    ///   - handler: 点击链接回调
    static func descPopopverView(showIn viewController: UIViewController,
                                 displayArrow: Bool = false,
                                 attributedMessage: NSAttributedString,
                                 activeKeys: [String]? = nil,
                                 fromView: UIView,
                                 handler: ((String) -> Void)?) {
        let popoverView = LKDescPopoverView(attributedMessage: attributedMessage, activeKeys: activeKeys)

        let popover = LKPopoverController(config: {
            var config = LKPopoverController.Config()
            config.isDisplayArrow = displayArrow
            return config
        }(), customView: popoverView, direction: .autoVertical, showInViewController: viewController, fromView: fromView)
        popover.show()
        
        popoverView.handler = { [weak popover] (text) in
            popover?.hidden(completion: {
                handler?(text)
            })
        }
    }
    
    /// 显示描述的浮窗
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - displayArrow: 是否显示倒三角
    ///   - attributedMessage: 描述信息
    ///   - activeKeys: 超链接
    ///   - convertFrame: 坐标
    ///   - handler: 点击链接回调
    static func descPopopverView(showIn viewController: UIViewController,
                                 displayArrow: Bool = false,
                                 attributedMessage: NSAttributedString,
                                 activeKeys: [String]? = nil,
                                 convertFrame: CGRect,
                                 handler: ((String) -> Void)?) {
        let popoverView = LKDescPopoverView(attributedMessage: attributedMessage, activeKeys: activeKeys)

        let popover = LKPopoverController(config: {
            var config = LKPopoverController.Config()
            config.isDisplayArrow = displayArrow
            return config
        }(), customView: popoverView, direction: .autoVertical, showInViewController: viewController, convertFrame: convertFrame)
        popover.show()
        
        popoverView.handler = { [weak popover] (text) in
            popover?.hidden(completion: {
                handler?(text)
            })
        }
    }
        
    /// 显示描述的浮窗
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - displayArrow: 是否显示倒三角
    ///   - message: 描述信息
    ///   - activeKeys: 超链接
    ///   - fromView: 锚点试图
    ///   - handler: 点击链接回调
    static func descPopopverView(showIn viewController: UIViewController,
                                 displayArrow: Bool = false,
                                 message: String,
                                 activeKeys: [String]? = nil,
                                 fromView: UIView,
                                 handler: ((String) -> Void)?) {
        Self.descPopopverView(showIn: viewController,
                              displayArrow: displayArrow,
                              attributedMessage: NSAttributedString(string: message, attributes: [.font : UIFont.lk.font(.nunitoSans, size: 14), .foregroundColor : UIColor.lk.text(.hex1B1B1B)]),
                              activeKeys: activeKeys,
                              fromView: fromView,
                              handler: handler)
    }
    
    /// 显示描述的浮窗
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - displayArrow: 是否显示倒三角
    ///   - message: 描述信息
    ///   - activeKeys: 超链接
    ///   - convertFrame: 坐标
    ///   - handler: 点击链接回调
    static func descPopopverView(showIn viewController: UIViewController,
                                 displayArrow: Bool = false,
                                 message: String,
                                 activeKeys: [String]? = nil,
                                 convertFrame: CGRect,
                                 handler: ((String) -> Void)?) {
        Self.descPopopverView(showIn: viewController,
                              displayArrow: displayArrow,
                              attributedMessage: NSAttributedString(string: message, attributes: [.font : UIFont.lk.font(.nunitoSans, size: 14), .foregroundColor : UIColor.lk.text(.hex1B1B1B)]),
                              activeKeys: activeKeys,
                              convertFrame: convertFrame,
                              handler: handler)
    }
    
}

public class LKDescPopoverView: UIView {

    var handler: ((String) -> Void)?
    
    private let attributedMessage: NSAttributedString?
    
    private let activeKeys: [String]?
    
    private lazy var contentView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.lk.color(.hexF3F3F3)
        aView.layer.cornerRadius = 4
        aView.layer.masksToBounds = true
        return aView
    }()
    
    private lazy var descLabel: UILabel = {
        func normalLabel() -> UILabel {
            let aLabel = UILabel()
            aLabel.numberOfLines = 0
            aLabel.font = UIFont.lk.font(.nunitoSans, size: 14)
            aLabel.textColor = UIColor.lk.text(.hex1B1B1B)
            aLabel.attributedText = attributedMessage
            return aLabel
        }
        
        func activeLabel() -> ActiveLabel {
            let aLabel = ActiveLabel()
            aLabel.numberOfLines = 0
            aLabel.font = UIFont.lk.font(.nunitoSans, size: 14)
            aLabel.textColor = UIColor.lk.text(.hex1B1B1B)
            aLabel.attributedText = attributedMessage
                    
            aLabel.enabledTypes = self.activeKeys?.map({
                let activeType = ActiveType.custom(pattern: $0)
                aLabel.handleCustomTap(for: activeType) { [weak self] (text) in
                    self?.handler?(text)
                }
                return activeType
            }) ?? []
            
            aLabel.customize { (label) in
                label.configureLinkAttribute = { (activeType, _, isSelected) in
                    return [.font: UIFont.lk.font(.nunitoSansBold, size: 14), .foregroundColor: UIColor.lk.text(.hex1B1B1B, alpha: isSelected ? 0.5 : 1), .underlineStyle: true]
                }
            }
            
            return aLabel
        }
        
        if activeKeys?.isEmpty ?? true {
            return normalLabel()
        }
        return activeLabel()
    }()
    
    
    required init(attributedMessage: NSAttributedString, activeKeys: [String]?) {
        self.attributedMessage = attributedMessage
        self.activeKeys = activeKeys
        
        super.init(frame: .zero)
        backgroundColor = .clear
        
        contentView.addSubview(descLabel)
        addSubview(contentView)
        
        descLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12))
            make.width.lessThanOrEqualTo(270.rate)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
