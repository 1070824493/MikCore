//
//  LKBaseHUDView.swift
//  LKCore
//
//  Created by m7 on 2021/11/24.
//

import UIKit

class LKBaseHUDView: UIView {

    public var style: LKToast.LKHUDStyle
    
    public required init(frame: CGRect, style: LKToast.LKHUDStyle) {
        self.style = style
        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
