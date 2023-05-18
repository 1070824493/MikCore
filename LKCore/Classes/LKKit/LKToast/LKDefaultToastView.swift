//
//  LKDefaultToastView.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/13.
//

import UIKit
import SnapKit

fileprivate extension LKToast.LKToastStyle {
    
    var isEmpty: Bool { (self.title?.isEmpty ?? true) && (self.message?.isEmpty ?? true) }
    
    var title: String? {
        switch self {
        case .information(let title, _): return title        
        case .success(let title, _): return title
        case .warn(let title, _): return title
        case .error(let title, _): return title
        }
    }
    
    var message: String? {
        switch self {
        case .information(_, let message): return message
        case .success(_, let message): return message
        case .warn(_, let message): return message
        case .error(_, let message): return message
        }
    }
    
    var attributeText: NSAttributedString? {
        typealias ColorsTuple = (titleColor: UIColor, messageColor: UIColor)
        
        let titleFont = UIFont.lk.font(.nunitoSansSemibold, size: 14)
        let messageFont = UIFont.lk.font(.nunitoSans, size: 14)
        
        let colorsTuple: ColorsTuple = {
            var titleColor: UIColor
            switch self {
            case .information(_, _): titleColor = UIColor.lk.text(.hex1B1B1B)
            case .success(_, _): titleColor = UIColor.lk.text(.hex009783)
            case .warn(_, _): titleColor = UIColor.lk.text(.hexA85D00)
            case .error(_, _): titleColor = UIColor.lk.text(.hexEB003B)
            }
            return (titleColor, UIColor.lk.text(.hex1B1B1B))
        }()
        
        let titleAttributedText: NSAttributedString? = {
            guard let title = self.title, !title.isEmpty else { return nil }
            return NSAttributedString(string: title, attributes: [.font: titleFont, .foregroundColor: colorsTuple.titleColor])
        }()
        
        let messageAttributedText: NSAttributedString? = {
            guard let message = self.message, !message.isEmpty else { return nil }
            return NSAttributedString(string: titleAttributedText == nil ? message : "\n" + message, attributes: [.font: messageFont, .foregroundColor: colorsTuple.messageColor])
        }()
        
        
        let bAttributeTexts = [titleAttributedText, messageAttributedText].compactMap({ $0 })
        guard !bAttributeTexts.isEmpty else { return nil }
        
        let mAttributedText = NSMutableAttributedString()
        bAttributeTexts.forEach({ mAttributedText.append($0) })
        return mAttributedText
    }
    
    var backgroundColor: UIColor? {
        switch self {
        case .information(_, _): return UIColor.lk.general(.hexFBFBFB)
        case .success(_, _): return UIColor.lk.general(.hexECF6F4)
        case .warn(_, _): return UIColor.lk.general(.hexF8F3EC)
        case .error(_, _): return UIColor.lk.general(.hexFEF5F8)
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .information(_, _): return UIColor.lk.general(.hex1B1B1B, alpha: 0.5)
        case .success(_, _): return UIColor.lk.text(.hex009783, alpha: 0.5)
        case .warn(_, _): return UIColor.lk.text(.hexA85D00, alpha: 0.5)
        case .error(_, _): return UIColor.lk.text(.hexEB003B, alpha: 0.5)
        }
    }
    
    var actionTextColor: UIColor {
        switch self {
        case .information(_, _): return UIColor.lk.text(.hex1B1B1B)
        case .success(_, _): return UIColor.lk.text(.hex009783)
        case .warn(_, _): return UIColor.lk.text(.hexA85D00)
        case .error(_, _): return UIColor.lk.text(.hexEB003B)
        }
    }
    
}

class LKDefaultToastView: UIView {

    private let style: LKToast.LKToastStyle
    
    private let action: LKToast.LKToastAction?
    
    private lazy var messageView: LKToastMessageView = {
        let aMessageView = LKToastMessageView()
        aMessageView.attributedText = style.attributeText
        aMessageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        aMessageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return aMessageView
    }()
    
    private lazy var actionBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12)
        aBtn.setTitleColor(style.actionTextColor, for: .normal)
        aBtn.setTitleColor(style.actionTextColor.withAlphaComponent(0.5), for: .highlighted)
        aBtn.setTitle(action?.title, for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnActionButton(_:)), for: .touchUpInside)
        aBtn.setContentCompressionResistancePriority(.required, for: .horizontal)
        aBtn.setContentHuggingPriority(.required, for: .horizontal)
        return aBtn
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: {
            if let _ = self.action { return [messageView, actionBtn] }
            return [messageView]
        }())
        aStackView.axis = .horizontal
        aStackView.alignment = .leading
        aStackView.distribution = .fill
        aStackView.spacing = 0
        return aStackView
    }()

    override var intrinsicContentSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 48, height: 36) }
    
    required init?(style: LKToast.LKToastStyle, action: LKToast.LKToastAction?) {
        guard !style.isEmpty else { return nil }
        
        self.style = style
        self.action = action
        
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Assistant
extension LKDefaultToastView {
    
    private func configure() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = style.borderColor?.cgColor
        layer.masksToBounds = true
    }
    
    private func setupSubviews() {
        addSubview(mStackView)
    }
    
    private func setupSubviewsConstraints() {
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width - 48)
        }
    }
    
}

// MARK: - Private
extension LKDefaultToastView {
    
    @objc
    private func didClickOnActionButton(_ sender: UIButton) {
        self.action?.actionHandler()
    }
    
}


// MARK: - LKToastMessageView
class LKToastMessageView: UIView {
    
    var attributedText: NSAttributedString? {
        didSet {
            self.messageLabel.attributedText = attributedText
        }
    }
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.lk.font(.nunitoSans, size: 14)
        aLabel.textColor = UIColor.lk.text(.hexFFFFFF)
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(messageLabel)
        
        messageLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 12, bottom: 10, right: 12))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
