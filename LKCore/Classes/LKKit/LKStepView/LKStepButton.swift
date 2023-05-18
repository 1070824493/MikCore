//
//  LKStepButton.swift
//  LKCore
//
//  Created by gaowei on 2021/4/20.
//

import UIKit

class LKStepButton: UIButton {

    lazy var lineView: UIView = {
        let item = UIView()
        item.backgroundColor = UIColor.lk.general(.hexCDCDCD)
        return item
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.lineView.frame = CGRect.init(x: 0, y: frame.size.height - 3.rate, width: frame.size.width, height: 3.rate)
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                self.lineView.backgroundColor = UIColor.lk.general(.hexCF1F2E)
            } else {
                self.lineView.backgroundColor = UIColor.lk.general(.hexF8D2CB)
            }
        }
    }
    
    
    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                self.lineView.backgroundColor = UIColor.lk.general(.hexF8D2CB)
            } else {
                self.lineView.backgroundColor = UIColor.lk.general(.hexCDCDCD)
            }
        }
    }
    
    
}
