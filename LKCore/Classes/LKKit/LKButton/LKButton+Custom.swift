//
//  LKButton+Custom.swift
//  LKCore
//
//  Created by m7 on 2021/4/23.
//

import UIKit

public struct LKCustomButtonConfig {
    
    /// background image for normal
    public var backgroundImage: UIImage? = UIImage.lk.image(UIColor.lk.general(.hexFFFFFF))
    
    /// background image for highlight
    public var highlightBackgroundImage: UIImage? = UIImage.lk.image(UIColor.lk.general(.hex1B1B1B, alpha: 0.07))
        
    /// background image for disabled
    public var disabledBackgroundImage: UIImage? = UIImage.lk.image(UIColor.lk.general(.hexCDCDCD))
    
    /// contentEdgeInsets
    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    
    /// font for title
    public var titleFont: UIFont = UIFont.lk.font(.nunitoSansBold, size: 14)
    
    /// title color for normal
    public var titleColor: UIColor = UIColor.lk.general(.hex1B1B1B)
    
    /// title color for highlight
    public var highlightTitleColor: UIColor = UIColor.lk.general(.hex1B1B1B)
    
    /// title color for disabled
    public var disabledTitleColor: UIColor = UIColor.lk.text(.hexFFFFFF)
    
    /// border color
    public var disableBorderColor: UIColor?
    
    /// border color
    public var borderColor: UIColor?
    
    /// border width
    public var borderWidth: CGFloat = 2
    
    
    public init() {}
    
}

// MARK: - General style buttons
public extension LKButton {
            
    enum Style {
        case normal, fillRed, fillBlack, borderRed, borderBlack, custom(config: LKCustomButtonConfig)
    }
    
    convenience init(style: Style) {
        self.init(config: style.config)
    }
    
    convenience init(config: LKCustomButtonConfig) {
        self.init(borderColorTuple: (config.borderColor?.cgColor, config.disableBorderColor?.cgColor))
        
        setBackgroundImage(config.backgroundImage, for: .normal)
        setBackgroundImage(config.highlightBackgroundImage, for: .highlighted)
        setBackgroundImage(config.disabledBackgroundImage, for: .disabled)
        setBorder(color: config.borderColor, width: config.borderWidth)
        contentEdgeInsets = config.contentEdgeInsets
        titleLabel?.font = config.titleFont
        setTitleColor(config.titleColor, for: .normal)
        setTitleColor(config.highlightTitleColor, for: .highlighted)
        setTitleColor(config.disabledTitleColor, for: .disabled)
    }
    
}


// MARK: - LKButton.Style
fileprivate extension LKButton.Style {
    
    var config: LKCustomButtonConfig {
        switch self {
        case .normal:
            var config = LKCustomButtonConfig()
            config.backgroundImage = UIImage.lk.image(UIColor.lk.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.lk.image(UIColor.lk.general(.hexFFFFFF))
            config.titleColor = UIColor.lk.general(.hex1B1B1B)
            config.highlightTitleColor = UIColor.lk.general(.hex1B1B1B, alpha: 0.5)
            config.disabledBackgroundImage = UIImage.lk.image(UIColor.lk.general(.hexFFFFFF))
            config.disabledTitleColor = UIColor.lk.general(.hex1B1B1B, alpha: 0.5)
            config.borderColor = nil
            return config
        case .fillRed:
            var config = LKCustomButtonConfig()
            config.backgroundImage = UIImage.lk.image(UIColor.lk.general(.hexCF1F2E))
            config.highlightBackgroundImage = UIImage.lk.image(UIColor.lk.general(.hexB01A27))
            config.titleColor = UIColor.lk.text(.hexFFFFFF)
            config.highlightTitleColor = UIColor.lk.text(.hexFFFFFF)
            return config
        case .fillBlack:
            var config = LKCustomButtonConfig()
            config.backgroundImage = UIImage.lk.image(UIColor.lk.general(.hex1B1B1B))
            config.highlightBackgroundImage = UIImage.lk.image(UIColor.lk.general(.hex5F5F5F))
            config.titleColor = UIColor.lk.text(.hexFFFFFF)
            config.highlightTitleColor = UIColor.lk.text(.hexFFFFFF)
            return config
        case .borderRed:
            var config = LKCustomButtonConfig()
            config.backgroundImage = UIImage.lk.image(UIColor.lk.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.lk.image(UIColor.lk.general(.hexFEF1EF))
            config.titleColor = UIColor.lk.general(.hexCF1F2E)
            config.highlightTitleColor = UIColor.lk.general(.hexCF1F2E)
            config.borderColor = UIColor.lk.general(.hexCF1F2E)
            return config
        case .borderBlack:
            var config = LKCustomButtonConfig()
            config.backgroundImage = UIImage.lk.image(UIColor.lk.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.lk.image(UIColor.lk.general(.hex1B1B1B, alpha: 0.07))
            config.titleColor = UIColor.lk.general(.hex1B1B1B)
            config.highlightTitleColor = UIColor.lk.general(.hex1B1B1B)
            config.borderColor = UIColor.lk.general(.hex1B1B1B)
            return config
        case .custom(let config): return config
        }
    }
    
}
