//
//  MikActivityHUDView.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/13.
//

import UIKit
import SnapKit

class MikActivityHUDView: MikBaseHUDView {
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let aIndicatorView = UIActivityIndicatorView(style: .medium)
        aIndicatorView.center = CGPoint(x: bounds.size.width * 0.5, y: bounds.size.height * 0.5)
        aIndicatorView.hidesWhenStopped = true
        aIndicatorView.color = UIColor.mik.general(.hex1B1B1B)
        return aIndicatorView
    }()
    
    
    required init(frame: CGRect) {
        super.init(frame: frame, style: .activity)
                
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(frame: CGRect, style: MikToast.MikHUDStyle) {
        fatalError("init(frame:style:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if let _ = superview {
            indicatorView.startAnimating()
        }
    }        
    
}

// MARK: - Assistant
extension MikActivityHUDView {
    
    private func setupSubviews() {
        addSubview(indicatorView)
    }
    
    private func setupSubviewsConstraints() {
        indicatorView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
}
