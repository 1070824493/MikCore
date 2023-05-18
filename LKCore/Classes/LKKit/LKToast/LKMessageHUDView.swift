//
//  LKMessageHUDView.swift
//  LKCore
//
//  Created by m7 on 2021/11/24.
//

import UIKit
import SnapKit


fileprivate extension LKToast.LKHUDStyle {
    
    var message: String? {
        switch self {
        case .message(let msg): return msg
        default: return nil
        }
    }
    
}

class LKMessageHUDView: LKBaseHUDView {
    
    override var style: LKToast.LKHUDStyle {
        didSet {
            guard style != oldValue else { return }
            switch style {
            case .message(let msg): self.nameLabel.text = msg
            default: break
            }
        }
    }
    
    private lazy var indicatorView: UIActivityIndicatorView = {
        let aIndicatorView = UIActivityIndicatorView(style: .medium)
        aIndicatorView.hidesWhenStopped = true
        aIndicatorView.color = UIColor.lk.general(.hex1B1B1B)
        return aIndicatorView
    }()
    
    private lazy var nameLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.lk.font(.nunitoSansBold, size: 16)
        aLabel.textColor = UIColor.lk.text(.hex1B1B1B)
        aLabel.textAlignment = .center
        aLabel.numberOfLines = 0
        aLabel.text = style.message
        return aLabel
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [indicatorView, nameLabel])
        aStackView.axis = .vertical
        aStackView.alignment = .center
        aStackView.distribution = .equalSpacing
        aStackView.spacing = 24
        return aStackView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let aView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        aView.alpha = 0.9
        return aView
    }()
    
    private lazy var contentView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.lk.general(.hexFFFFFF, alpha: 0.9)
        aView.layer.cornerRadius = 16
        aView.layer.masksToBounds = true
        return aView
    }()
    
    required init(frame: CGRect, message: String?) {
        super.init(frame: frame, style: .message(message))
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public required init(frame: CGRect, style: LKToast.LKHUDStyle) {
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
extension LKMessageHUDView {
    
    private func setupSubviews() {
        contentView.addSubview(blurView)
        contentView.addSubview(mStackView)
        addSubview(contentView)
    }
    
    private func setupSubviewsConstraints() {
        blurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(24)
        }
        
        contentView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().multipliedBy(0.6)
            make.height.lessThanOrEqualToSuperview().multipliedBy(0.8)
        }
    }
    
}
