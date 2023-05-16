//
//  MikButton.swift
//  MikCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit

fileprivate let kContentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
fileprivate let kDefaultFont = UIFont.mik.font(.nunitoSansBold, size: 14)

open class MikButton: UIButton {
    
    typealias BorderColorTuple = (enable: CGColor?, disable: CGColor?)
    
    private var borderColorTuple: BorderColorTuple? = nil
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    convenience init(borderColorTuple: BorderColorTuple) {
        self.init(frame: .zero)
        self.borderColorTuple = borderColorTuple
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    open override var isEnabled: Bool {
        didSet {
            self.layer.borderColor = {
                let color = isEnabled ? self.borderColorTuple?.enable : self.borderColorTuple?.disable
                return color ?? UIColor.clear.cgColor
            }()
        }
    }
    
    public func setBackgroundImageWithColor(_ color: UIColor, state: UIControl.State) {
        setBackgroundImage(UIImage.mik.image(color), for: state)
    }
    
    public func setBorder(color: UIColor?, width: CGFloat = 2) {
        guard let color = color, width > 0 else { return }
        layer.borderColor = color.cgColor
        layer.borderWidth = width
    }
    
    public func setCorner(radius: CGFloat) {
        layer.cornerRadius = max(radius, 0)
        layer.masksToBounds = radius != 0
    }
}

// MARK: - Assistant
extension MikButton {
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        contentEdgeInsets = kContentEdgeInsets
        titleLabel?.font = kDefaultFont
    }
    
}
