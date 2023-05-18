//
//  LKLogoHUDView.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/12.
//

import UIKit
import SnapKit
import Kingfisher

class LKLogoHUDView: LKBaseHUDView {

    private lazy var gifView: AnimatedImageView = {
        let aImgView = AnimatedImageView()
        aImgView.clipsToBounds = true
        aImgView.contentMode = .scaleAspectFill
        aImgView.runLoopMode = .common
        
        if let sourcePath = Bundle.lk.default.path(forResource: "lk_animation_logo", ofType: "gif") {
            aImgView.kf.setImage(with: LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: sourcePath), cacheKey: "com.lk.logo_animations"))
        }
        
        return aImgView
    }()
    
    required init(frame: CGRect) {
        super.init(frame: frame, style: .logo)
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(frame: CGRect, style: LKToast.LKHUDStyle) {
        fatalError("init(frame:style:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension LKLogoHUDView {
    
    private func setupSubviews() {
        addSubview(gifView)
    }
    
    private func setupSubviewsConstraints() {
        gifView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 180.rate, height: 48.rate))
        }
    }
    
}
