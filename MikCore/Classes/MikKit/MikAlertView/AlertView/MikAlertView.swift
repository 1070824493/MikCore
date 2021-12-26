//
//  MikAlertView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit
import SnapKit


fileprivate let kMaxWidth: CGFloat = 288.rate
fileprivate let kContentMaxWidth: CGFloat = 240.rate
fileprivate let kScrollViewMaxHeight: CGFloat = 400.hRate

// MARK: - Public meds
public extension MikAlertView {
    
    static let kActionButtonHeight: CGFloat = 50
    
    @discardableResult
    static func alertView(title: String?,
                          message: String?,
                          showInView viewController: UIViewController,
                          actions: [MikAlertAction]) -> MikAlertViewController {
        let message: NSAttributedString? = {
            guard let message = message else { return nil }
            return NSAttributedString(string: message, attributes: [.font: UIFont.mik.font(.nunitoSans, size: 14), .foregroundColor: UIColor.mik.text(.hex1B1B1B)])
        }()
        
        return Self.alertView(title: title, attributedMessage: message, showInView: viewController, actions: actions)
    }
    
    @discardableResult
    static func alertView(title: String?,
                          attributedMessage: NSAttributedString?,
                          showInView viewController: UIViewController,
                          actions: [MikAlertAction]) -> MikAlertViewController {        
        let alertView = MikAlertView(title: title, message: attributedMessage, actions: actions)
        
        let alertViewController = MikAlertViewController(view: alertView)
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

public class MikAlertView: UIView {

    typealias SelectCallback = (_ action: MikAlertAction) -> Void
    
    var selectBlock: SelectCallback?
    
    
    private var messageScrollViewHeight: CGFloat {
        messageLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
    }
    
    private let actions: [MikAlertAction]
    
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
        aLabel.font = UIFont.mik.font(.nunitoSansBold, size: 16)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
        aLabel.preferredMaxLayoutWidth = kContentMaxWidth
        aLabel.textAlignment = .center
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.nunitoSans, size: 14)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
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
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hex1B1B1B)), for: .normal)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hex5F5F5F)), for: .highlighted)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        aBtn.titleLabel?.numberOfLines = 2
        aBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14)
        aBtn.setTitleColor(UIColor.mik.text(.hexFFFFFF), for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnActionButton(_:)), for: .touchUpInside)
        return aBtn
    }
    
    required public init(title: String?, message: NSAttributedString?, actions: [MikAlertAction]) {
        self.actions = actions

        super.init(frame: .zero)
        self.backgroundColor = UIColor.mik.general(.hexFFFFFF)
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
        
        
        defer { messageScrollView.bounces = self.messageScrollViewHeight > kScrollViewMaxHeight }
        
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
extension MikAlertView {
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
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
extension MikAlertView {
    
    @objc
    private func didClickOnActionButton(_ sender: UIButton) {
        guard let idx = self.actionButtons.firstIndex(where: { $0 == sender }) else {
            return
        }
        
        self.selectBlock?(self.actions[idx])
    }
    
}
