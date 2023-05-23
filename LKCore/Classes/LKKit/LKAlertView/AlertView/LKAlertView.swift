//
//  LKAlertView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit
import SnapKit


fileprivate let kContentMaxWidth: CGFloat = 240.rate
fileprivate let kScrollViewMaxHeight: CGFloat = 400.hRate

// MARK: - Public meds
public extension LKAlertView {
    
    static let kActionButtonHeight: CGFloat = 50
    
    @discardableResult
    static func alertView(title: String?,
                          message: String?,
                          showInView viewController: UIViewController,
                          actions: [LKAlertAction]) -> LKAlertViewController {
        let message: NSAttributedString? = {
            guard let message = message else { return nil }
            return NSAttributedString(string: message, attributes: [.font: UIFont.lk.font(.nunitoSans, size: 14), .foregroundColor: UIColor.lk.text(.hex1B1B1B)])
        }()
        
        return Self.alertView(title: title, attributedMessage: message, showInView: viewController, actions: actions)
    }
    
    @discardableResult
    static func alertView(title: String?,
                          attributedMessage: NSAttributedString?,
                          showInView viewController: UIViewController,
                          actions: [LKAlertAction]) -> LKAlertViewController {        
        let alertView = LKAlertView(title: title, message: attributedMessage, actions: actions)
        
        let alertViewController = LKAlertViewController(view: alertView)
        alertViewController.showInViewController(viewController, nil)
        
        alertView.selectBlock = { [weak alertViewController] (action) in
            if action.isHiddenEnable {
                alertViewController?.hidden({
                    action.handle?()
                })
            }else { action.handle?() }            
        }
        
        return alertViewController
    }
    
}

public class LKAlertView: UIView {

    typealias SelectCallback = (_ action: LKAlertAction) -> Void
    
    var selectBlock: SelectCallback?
    
    
    private var messageScrollViewHeight: CGFloat {
        messageLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    
    private let actions: [LKAlertAction]
    
    private lazy var actionButtons: [UIButton] = actions.map({ _ in self.createActionButton() })
    
    private lazy var descStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.messageScrollView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 16
        aStackView.distribution = .fill
        return aStackView
    }()
    
    private lazy var actionsStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: self.actionButtons)
        aStackView.axis = .horizontal
        aStackView.alignment = .fill
        aStackView.spacing = 24
        aStackView.distribution = .fillEqually
        return aStackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.lk.font(.IBMPlexSerifBold, size: 16)
        aLabel.textColor = UIColor.lk.text(.hex1B1B1B)
        aLabel.preferredMaxLayoutWidth = kContentMaxWidth
        aLabel.textAlignment = .center
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.lk.font(.nunitoSans, size: 14)
        aLabel.textColor = UIColor.lk.text(.hex1B1B1B)
        aLabel.preferredMaxLayoutWidth = kContentMaxWidth
        aLabel.textAlignment = .center
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var messageScrollView: UIScrollView = {
        let aScrollView = UIScrollView()
        aScrollView.showsHorizontalScrollIndicator = false
        aScrollView.showsVerticalScrollIndicator = false
        aScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        return aScrollView
    }()
    
    private func createActionButton() -> UIButton {
        let aBtn = UIButton()
        aBtn.setBackgroundImage(UIImage.lk.image(UIColor.lk.color(.hex1B1B1B)), for: .normal)
        aBtn.setBackgroundImage(UIImage.lk.image(UIColor.lk.color(.hex5F5F5F)), for: .highlighted)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        aBtn.titleLabel?.numberOfLines = 2
        aBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14)
        aBtn.setTitleColor(UIColor.lk.text(.hexFFFFFF), for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnActionButton(_:)), for: .touchUpInside)
        return aBtn
    }
    
    required public init(title: String?, message: NSAttributedString?, actions: [LKAlertAction]) {
        self.actions = actions

        super.init(frame: .zero)
        self.backgroundColor = UIColor.lk.color(.hexFFFFFF)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        
        self.titleLabel.text = title
        self.messageLabel.attributedText = message
        
        if title?.isEmpty ?? true {
            self.descStackView.removeArrangedSubview(titleLabel)
            self.titleLabel.isHidden = true
        }
        
        if message?.string.isEmpty ?? true {
            self.descStackView.removeArrangedSubview(messageScrollView)
            self.messageScrollView.isHidden = true
        }
        
        actions.enumerated().forEach({
            $1.custom?(self.actionButtons[$0])
        })
        
        
        defer { messageScrollView.bounces = messageScrollViewHeight > kScrollViewMaxHeight }
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Assistant
extension LKAlertView {
    
    private func configure() {
        backgroundColor = UIColor.lk.color(.hexFFFFFF)
    }
    
    private func setupSubviews() {
        messageScrollView.addSubview(messageLabel)
        
        addSubview(descStackView)
        addSubview(actionsStackView)
    }
    
    private func setupSubviewsConstraints() {
        messageLabel.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalTo(kContentMaxWidth)
        }
        
        messageScrollView.snp.makeConstraints { make in
            make.height.equalTo(min(messageScrollViewHeight, kScrollViewMaxHeight))
        }
        
        descStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24).priority(.high)
            make.left.right.equalToSuperview().inset(24)
            make.width.equalTo(kContentMaxWidth)
            make.centerX.equalToSuperview()
        }
        
        actionsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descStackView.snp.bottom).offset(48.rate)
            make.bottom.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(kContentMaxWidth)
            make.height.equalTo(Self.kActionButtonHeight)
        }
    }
}

// MARK: - Private meds
extension LKAlertView {
    
    @objc
    private func didClickOnActionButton(_ sender: UIButton) {
        guard let idx = self.actionButtons.firstIndex(where: { $0 == sender }) else {
            return
        }
        
        self.selectBlock?(self.actions[idx])
    }
    
}
