//
//  UIStackView.swift
//  LKCore
//
//  Created by m7 on 2021/5/18.
//

import UIKit


public extension LKNameSpace where Base: UIStackView {
    
    func addArrangedSubviewsCompletely(_ subviews: [UIView]?) {
        guard let subviews = subviews else { return }
        subviews.forEach({ base.addArrangedSubview($0) })
    }
    
    func removeArrangedSubviewCompletely(_ subview: UIView) {
        base.removeArrangedSubview(subview)
        subview.removeFromSuperview()
    }

    func removeAllArrangedSubviewsCompletely() {
        for subview in base.arrangedSubviews.reversed() {
            removeArrangedSubviewCompletely(subview)
        }
    }
    
}
