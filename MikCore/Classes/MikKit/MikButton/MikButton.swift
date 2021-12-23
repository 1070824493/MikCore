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
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
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
