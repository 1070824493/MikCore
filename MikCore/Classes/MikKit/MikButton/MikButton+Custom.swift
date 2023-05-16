//
//  MikButton+Custom.swift
//  MikCore
//
//  Created by m7 on 2021/4/23.
//

import UIKit

public struct MikCustomButtonConfig {
    
    /// background image for normal
    public var backgroundImage: UIImage? = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
    
    /// background image for highlight
    public var highlightBackgroundImage: UIImage? = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        
    /// background image for disabled
    public var disabledBackgroundImage: UIImage? = UIImage.mik.image(UIColor.mik.general(.hexCDCDCD))
    
    /// contentEdgeInsets
    public var contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
    
    /// font for title
    public var titleFont: UIFont = UIFont.mik.font(.nunitoSansBold, size: 14)
    
    /// title color for normal
    public var titleColor: UIColor = UIColor.mik.general(.hex1B1B1B)
    
    /// title color for highlight
    public var highlightTitleColor: UIColor = UIColor.mik.general(.hex1B1B1B)
    
    /// title color for disabled
    public var disabledTitleColor: UIColor = UIColor.mik.text(.hexFFFFFF)
    
    /// border color
    public var disableBorderColor: UIColor?
    
    /// border color
    public var borderColor: UIColor?
    
    /// border width
    public var borderWidth: CGFloat = 2
    
    
    public init() {}
    
}

// MARK: - General style buttons
public extension MikButton {
            
    enum Style {
        case normal, fillRed, fillBlack, borderRed, borderBlack, custom(config: MikCustomButtonConfig)
    }
    
    convenience init(style: Style) {
        self.init(config: style.config)
    }
    
    convenience init(config: MikCustomButtonConfig) {
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


// MARK: - MikButton.Style
fileprivate extension MikButton.Style {
    
    var config: MikCustomButtonConfig {
        switch self {
        case .normal:
            var config = MikCustomButtonConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.titleColor = UIColor.mik.general(.hex1B1B1B)
            config.highlightTitleColor = UIColor.mik.general(.hex1B1B1B, alpha: 0.5)
            config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.disabledTitleColor = UIColor.mik.general(.hex1B1B1B, alpha: 0.5)
            config.borderColor = nil
            return config
        case .fillRed:
            var config = MikCustomButtonConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexCF1F2E))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexB01A27))
            config.titleColor = UIColor.mik.text(.hexFFFFFF)
            config.highlightTitleColor = UIColor.mik.text(.hexFFFFFF)
            return config
        case .fillBlack:
            var config = MikCustomButtonConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex5F5F5F))
            config.titleColor = UIColor.mik.text(.hexFFFFFF)
            config.highlightTitleColor = UIColor.mik.text(.hexFFFFFF)
            return config
        case .borderRed:
            var config = MikCustomButtonConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFEF1EF))
            config.titleColor = UIColor.mik.general(.hexCF1F2E)
            config.highlightTitleColor = UIColor.mik.general(.hexCF1F2E)
            config.borderColor = UIColor.mik.general(.hexCF1F2E)
            return config
        case .borderBlack:
            var config = MikCustomButtonConfig()
            config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
            config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
            config.titleColor = UIColor.mik.general(.hex1B1B1B)
            config.highlightTitleColor = UIColor.mik.general(.hex1B1B1B)
            config.borderColor = UIColor.mik.general(.hex1B1B1B)
            return config
        case .custom(let config): return config
        }
    }
    
}
