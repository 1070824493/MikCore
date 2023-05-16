//
//  MikAlertAction.swift
//  MikCore
//
//  Created by m7 on 2021/4/23.
//

import UIKit

public class MikAlertAction {
    
    public typealias CustomCallback = (_ button: UIButton) -> Void
    public typealias HandleCallback = () -> Void
    
    private(set) var custom: CustomCallback?
    private(set) var handle: HandleCallback?
    public var isHiddenEnable: Bool = true
    
    required public init(custom: CustomCallback? = nil, handle: HandleCallback? = nil) {
        self.custom = custom
        self.handle = handle
    }
    
    static public func action(custom: CustomCallback? = nil, handle: HandleCallback? = nil) -> MikAlertAction {
        return MikAlertAction(custom: custom, handle: handle)
    }
    
}

public extension MikAlertAction {
    
    enum Style {
        case normal, fillRed, fillBlack, borderRed, borderBlack
    }
    
}

// MARK: - MikButton.Style
fileprivate extension MikAlertAction.Style {
    
    struct StyleConfig {
        
        /// background image for normal
        var backgroundImage: UIImage? = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
        /// background image for highlight
        var highlightBackgroundImage: UIImage? = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        /// background image for disabled
        var disabledBackgroundImage: UIImage? = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        /// contentEdgeInsets
        var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        /// font for title
        var titleFont: UIFont = UIFont.mik.font(.nunitoSansBold, size: 14)
        /// title color for normal
        var titleColor: UIColor = UIColor.mik.general(.hex1B1B1B)
        /// title color for highlight
        var highlightTitleColor: UIColor = UIColor.mik.general(.hex1B1B1B)
        /// title color for disabled
        var disabledTitleColor: UIColor = UIColor.mik.general(.hex1B1B1B)
        /// border color
        var borderColor: UIColor?
        /// border width
        var borderWidth: CGFloat = 2
        /// corner radius
        var cornerRadius: CGFloat = 0
        
    }
    
    var config: StyleConfig {
        switch self {
        case .normal:
            var config = StyleConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.titleColor = UIColor.mik.general(.hex1B1B1B)
            config.highlightTitleColor = UIColor.mik.general(.hex1B1B1B, alpha: 0.5)
            config.disabledTitleColor = UIColor.mik.general(.hex1B1B1B, alpha: 0.5)
            config.borderColor = nil
            config.cornerRadius = 0
            return config
        case .fillRed:
            var config = StyleConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexCF1F2E))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexEB003B))
            config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexCDCDCD))
            config.titleColor = UIColor.mik.text(.hexFFFFFF)
            config.highlightTitleColor = UIColor.mik.text(.hexFFFFFF)
            config.disabledTitleColor = UIColor.mik.text(.hexFFFFFF)
            config.borderColor = nil
            config.cornerRadius = 25
            return config
        case .fillBlack:
            var config = StyleConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex5F5F5F))
            config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexCDCDCD))
            config.titleColor = UIColor.mik.text(.hexFFFFFF)
            config.highlightTitleColor = UIColor.mik.text(.hexFFFFFF)
            config.disabledTitleColor = UIColor.mik.text(.hexFFFFFF)
            config.borderColor = nil
            config.cornerRadius = 25
            return config
        case .borderRed:
            var config = StyleConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
            config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
            config.titleColor = UIColor.mik.general(.hexCF1F2E)
            config.highlightTitleColor = UIColor.mik.general(.hexEB003B)
            config.disabledTitleColor = UIColor.mik.general(.hexEB003B)
            config.borderColor = UIColor.mik.general(.hexCF1F2E)
            config.cornerRadius = 25
            return config
        case .borderBlack:
            var config = StyleConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
            config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
            config.titleColor = UIColor.mik.general(.hex1B1B1B)
            config.highlightTitleColor = UIColor.mik.general(.hex1B1B1B)
            config.disabledTitleColor = UIColor.mik.general(.hex1B1B1B)
            config.borderColor = UIColor.mik.general(.hex1B1B1B)
            config.cornerRadius = 25
            return config
        }
    }
    
}

public extension MikAlertAction {
    
    /// 初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - style: 样式
    ///   - handle: 事件回调
    static func action(title: String, style: Style = .normal, handle: HandleCallback? = nil) -> MikAlertAction {
        return MikAlertAction(custom: { (aBtn) in
            aBtn.setBackgroundImage(style.config.backgroundImage, for: .normal)
            aBtn.setBackgroundImage(style.config.highlightBackgroundImage, for: .highlighted)
            aBtn.setBackgroundImage(style.config.disabledBackgroundImage, for: .disabled)
            aBtn.contentEdgeInsets = style.config.contentEdgeInsets
            aBtn.titleLabel?.font = style.config.titleFont
            aBtn.setTitle(title, for: .normal)
            aBtn.setTitleColor(style.config.titleColor, for: .normal)
            aBtn.setTitleColor(style.config.highlightTitleColor, for: .highlighted)
            aBtn.setTitleColor(style.config.disabledTitleColor, for: .disabled)
            if let color = style.config.borderColor, style.config.borderWidth > 0 {
                aBtn.layer.borderColor = color.cgColor
                aBtn.layer.borderWidth = style.config.borderWidth
            }
            if style.config.cornerRadius > 0 {
                aBtn.layer.cornerRadius = min(style.config.cornerRadius, MikAlertView.kActionButtonHeight * 0.5)
                aBtn.layer.masksToBounds = true
            }
        }, handle: handle)
    }
    
    /// 常用‘Cancel’样式工厂方法
    /// - Parameters:
    ///   - title: 标题
    ///   - handle: 事件回调
    static func cancelAction(title: String = "Cancel", handle: HandleCallback? = nil) -> MikAlertAction {
        return Self.action(title: title.mik.capitalized(), style: .borderRed, handle: handle)
    }
    
    /// 常用‘Confirm’样式工厂方法
    /// - Parameters:
    ///   - title: 标题
    ///   - handle: 事件回调
    static func confirmAction(title: String = "Confirm", handle: HandleCallback? = nil) -> MikAlertAction {
        return Self.action(title: title.mik.capitalized(), style: .fillRed, handle: handle)
    }
    
}
