//
//  MikBaseHUDView.swift
//  MikCore
//
//  Created by m7 on 2021/11/24.
//

import UIKit

class MikBaseHUDView: UIView {

    public var style: MikToast.MikHUDStyle
    
    public required init(frame: CGRect, style: MikToast.MikHUDStyle) {
        self.style = style
        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
