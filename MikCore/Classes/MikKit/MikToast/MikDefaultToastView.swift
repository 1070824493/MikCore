//
//  MikDefaultToastView.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/13.
//

import UIKit
import SnapKit

fileprivate extension MikToast.MikToastStyle {
    
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
        let titleFont = UIFont.mik.font(.nunitoSans, size: 14)
        let messageFont = UIFont.mik.font(.nunitoSans, size: 12)
        
        let colorsTuple: ColorsTuple = {
            var titleColor: UIColor
            switch self {
            case .information(let title, let message):
                if !(title?.isEmpty ?? true), !(message?.isEmpty ?? true) {
                    titleColor = UIColor.mik.text(.hexD1E8F8)
                }else {
                    titleColor = UIColor.mik.text(.hexFFFFFF)
                }
            case .success(_, _): titleColor = UIColor.mik.text(.hexC5E4C8)
            case .warn(_, _): titleColor = UIColor.mik.text(.hexFFF2DF)
            case .error(_, _): titleColor = UIColor.mik.text(.hexF8D2CB)
            }
            return (titleColor, UIColor.mik.text(.hexFFFFFF))
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
    
    var actionTextColor: UIColor {
        switch self {
        case .information(let title, let message):
            if !(title?.isEmpty ?? true), !(message?.isEmpty ?? true) {
                return UIColor.mik.text(.hexD1E8F8)
            }
            return UIColor.mik.text(.hexFFFFFF)
        case .success(_, _): return UIColor.mik.text(.hexC5E4C8)
        case .warn(_, _): return UIColor.mik.text(.hexFFF2DF)
        case .error(_, _): return UIColor.mik.text(.hexF8D2CB)
        }
    }
    
}

class MikDefaultToastView: UIView {

    private let style: MikToast.MikToastStyle
    
    private let action: MikToast.MikToastAction?
    
    private lazy var messageView: MikToastMessageView = {
        let aMessageView = MikToastMessageView()
        aMessageView.attributedText = style.attributeText
        aMessageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        aMessageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return aMessageView
    }()
    
    private lazy var actionBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 12)
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
            var bSubviews: [UIView] = [messageView]
            if let _ = self.action { bSubviews.append(actionBtn) }
            return bSubviews
        }())
        aStackView.axis = .horizontal
        aStackView.alignment = .leading
        aStackView.distribution = .fill
        aStackView.spacing = 0
        return aStackView
    }()

    override var intrinsicContentSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 48, height: 36) }
    
    required init?(style: MikToast.MikToastStyle, action: MikToast.MikToastAction?) {
        guard !style.isEmpty else { return nil }
        
        self.style = style
        self.action = action
        
        super.init(frame: .zero)
        backgroundColor = UIColor.mik.general(.hex303030)
        layer.cornerRadius = 4
        layer.masksToBounds = true
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension MikDefaultToastView {
    
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
extension MikDefaultToastView {
    
    @objc
    private func didClickOnActionButton(_ sender: UIButton) {
        self.action?.actionHandler()
    }
    
}


// MARK: - MikToastMessageView
class MikToastMessageView: UIView {
    
    var attributedText: NSAttributedString? {
        didSet {
            self.messageLabel.attributedText = attributedText
        }
    }
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.nunitoSans, size: 14)
        aLabel.textColor = UIColor.mik.text(.hexFFFFFF)
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
