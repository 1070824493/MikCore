//
//  LKScrollView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit
import SnapKit

public extension LKScrollView {
    
    enum Axis {
        case horizontal, vertical
    }
    
}

open class LKScrollView: UIScrollView {
    
    private let axis: Axis
    
    open override var intrinsicContentSize: CGSize { UIScreen.main.bounds.size }
    
    required public init(axis: Axis) {
        self.axis = axis
        
        super.init(frame: .zero)
        backgroundColor = UIColor.lk.color(.hexFFFFFF)
        bounces = true
        alwaysBounceHorizontal = axis == .horizontal
        alwaysBounceVertical = axis == .vertical
        keyboardDismissMode = .onDrag
        contentInsetAdjustmentBehavior = .never
        automaticallyAdjustsScrollIndicatorInsets = false
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Assistant
extension LKScrollView {
    
    private func setupSubviews() {}
    
    private func setupSubviewsConstraints() {}
    
}

// MARK: - Public
extension LKScrollView {
    
    public func setupSubViews(_ views: [UIView]?) {
        self.subviews.forEach({ $0.removeFromSuperview() })
        views?.forEach({ self.addSubview($0) })
    }
    
}
