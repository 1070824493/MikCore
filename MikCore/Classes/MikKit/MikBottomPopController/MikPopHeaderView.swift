//
//  MikPopHeaderView.swift
//  MikCore
//
//  Created by gaowei on 2021/5/10.
//

import UIKit
import SnapKit

open class MikPopHeaderView: UIView {
    
    public var closeHandler: (() -> Void)?
    
    public var title: String? {
        didSet {
            self.titleLabel.text = title
        }
    }
    
    public private(set) lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.IBMPlexSerifBold, size: 16.rate)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
        aLabel.text = title
        return aLabel
    }()
    
    public private(set) lazy var closeBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        aBtn.setImage(UIImage.image("nav_del"), for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnCloseButton(_:)), for: .touchUpInside)
        return aBtn
    }()
    
    public private(set) lazy var separateView: UIView = {
        let aView = UIView()
        aView.isUserInteractionEnabled = false
        aView.backgroundColor = UIColor.mik.general(.hexEAEAEA)
        return aView
    }()
    
    open override var intrinsicContentSize: CGSize { CGSize(width: UIScreen.main.bounds.width, height: 52.rate) }
    
    required public init(title: String) {
        self.title = title
        
        super.init(frame: .zero)
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension MikPopHeaderView {
    
    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(closeBtn)
        addSubview(separateView)
    }
    
    private func setupSubviewsConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        closeBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
        }
        
        separateView.snp.makeConstraints { (make) in
            make.bottom.width.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
}
extension MikPopHeaderView {
    
    @objc
    private func didClickOnCloseButton(_ sender: UIButton) {
        self.closeHandler?()
    }
    
}
