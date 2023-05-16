//
//  MikInputAlertView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

fileprivate let kActionButtonHeight: CGFloat = 50

// MARK: - Public meds
public extension MikInputAlertView {
    
    typealias InputViewsTuple = (controller: MikAlertViewController, inputView: MikInputAlertView)
    
    static func inputAlertView(title: String?,
                               message: String?,
                               placeholder: String? = nil,
                               showInView viewController: UIViewController,
                               actions: [MikAlertAction]) -> InputViewsTuple {
        let inputAlertView = MikInputAlertView(title: title, message: message, placeholder: placeholder, actions: actions)        
        inputAlertView.selectBlock = { (action) in
            action.handle?()
        }

        let alertViewController = MikAlertViewController(view: inputAlertView)
        alertViewController.showInViewController(viewController, nil)
        
        return (alertViewController, inputAlertView)
    }
    
}

public class MikInputAlertView: UIView {

    typealias SelectCallback = (_ action: MikAlertAction) -> Void
    public typealias TextChangedCallback = (String?) -> Void
    
    var selectBlock: SelectCallback?
    
    private var actions: [MikAlertAction]!
    
    private var actionButtons: [UIButton]!
    
    private var inputText: String?
    
    private lazy var descStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.messageLabel, self.textInputView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 24
        aStackView.distribution = .equalSpacing
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
        aLabel.font = UIFont.mik.font(.IBMPlexSerifBold, size: 16)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
        aLabel.numberOfLines = 0
        aLabel.textAlignment = .center
        return aLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.nunitoSans, size: 14)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
        aLabel.textAlignment = .center
        aLabel.numberOfLines = 0
        return aLabel
    }()
    
    //public easy to custom
    public lazy var textInputView: UITextField = {
        let textField = UITextField()
        textField.isSecureTextEntry = true
        textField.textColor = UIColor.mik.text(.hex1B1B1B)
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.mik.general(.hexAEAEAE).cgColor
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 50))
        textField.leftViewMode = .always
        return textField
    }()
    
    
    private func createActionButton() -> UIButton {
        let aBtn = UIButton()
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hex1B1B1B)), for: .normal)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hex5F5F5F)), for: .highlighted)
        aBtn.layer.cornerRadius = kActionButtonHeight * 0.5        
        aBtn.layer.masksToBounds = true
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        aBtn.titleLabel?.numberOfLines = 2
        aBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14)
        aBtn.setTitleColor(UIColor.mik.text(.hexFFFFFF), for: .normal)
        aBtn.setTitle("Confirm", for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnActionButton(_:)), for: .touchUpInside)
        return aBtn
    }
    
    required public init(title: String?, message: String?, placeholder: String?, actions: [MikAlertAction]) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.mik.general(.hexFFFFFF)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true
        self.actions = actions
        self.actionButtons = actions.map({ _ in self.createActionButton() })
        
        self.titleLabel.text = title
        self.messageLabel.text = message
        self.textInputView.placeholder = placeholder
        
        if title?.isEmpty ?? true {
            self.descStackView.removeArrangedSubview(titleLabel)
            self.titleLabel.isHidden = true
        }
        
        if message?.isEmpty ?? true {
            self.descStackView.removeArrangedSubview(messageLabel)
            self.messageLabel.isHidden = true
        }
        
        actions.enumerated().forEach({
            $1.custom?(self.actionButtons[$0])
        })
        
        setupSubviews()
        setupSubviewsConstraints()
        setupObservers()
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension MikInputAlertView {
    
    private func setupSubviews() {
        addSubview(descStackView)
        addSubview(actionsStackView)
    }
    
    private func setupSubviewsConstraints() {
        descStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24.rate).priority(.high)
            make.left.right.equalToSuperview().inset(24.rate)
            make.width.equalTo(263.rate)
            make.centerX.equalToSuperview()
        }
        
        actionsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descStackView.snp.bottom).offset(30.rate)
            make.bottom.equalToSuperview().inset(24.rate)
            make.centerX.equalToSuperview()
            make.width.equalTo(263.rate)
            make.height.equalTo(kActionButtonHeight)
        }
        
        textInputView.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview().inset(24.rate)
            make.height.equalTo(50.rate)
        }
    }
    
    private func setupObservers() {
        textInputView.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc func textDidChange() {
        self.inputText = textInputView.text
    }
}

// MARK: - Private meds
extension MikInputAlertView {
    
    @objc
    private func didClickOnActionButton(_ sender: UIButton) {
        guard let idx = self.actionButtons?.firstIndex(where: { $0 == sender }) else {
            return
        }
        
        self.selectBlock?(self.actions[idx])
    }
    
}

// MARK: - Public meds
public extension MikInputAlertView {
    
    /// 输入的文本内容
    var text: String? { self.inputText }
    
}
