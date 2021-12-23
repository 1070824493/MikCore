//
//  MikLogoHUDView.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/12.
//

import UIKit
import SnapKit
import Kingfisher

class MikLogoHUDView: MikBaseHUDView {

    private lazy var gifView: AnimatedImageView = {
        let aImgView = AnimatedImageView()
        aImgView.clipsToBounds = true
        aImgView.contentMode = .scaleAspectFill
        aImgView.runLoopMode = .common
        
        if let sourcePath = Bundle.mik.default.path(forResource: "mik_animation_logo", ofType: "gif") {
            aImgView.kf.setImage(with: LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: sourcePath), cacheKey: "com.mik.logo_animations"))
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
    
    public required init(frame: CGRect, style: MikToast.MikHUDStyle) {
        fatalError("init(frame:style:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension MikLogoHUDView {
    
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
