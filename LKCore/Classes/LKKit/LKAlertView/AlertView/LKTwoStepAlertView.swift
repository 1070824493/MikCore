//
//  LKEmailAlertView.swift
//  LKCore
//
//  Created by m7 on 2022/1/4.
//

import UIKit
import SnapKit
import RxSwift


fileprivate let kContentMaxWidth: CGFloat = 240.rate
fileprivate let kActionButtonHeight: CGFloat = 50
fileprivate let kGetCodeCountDownDuration = 60
fileprivate let kGetCodeText = "Get Code"

public enum LKTwoStepAlertViewType {
    case email(String)
    case phone(String)
}

fileprivate extension LKTwoStepAlertViewType {
    var isEditable: Bool { false }
    
    var title: String? {
        switch self {
        case .email(_): return "E-Mail"
        case .phone(_): return "Phone Number"
        }
    }
    
    var value: String? {
        switch self {
        case .email(let email): return email
        case .phone(let phone): return phone
        }
    }
    
    var textFieldStyle: LKTextFieldFormatterView.CustomFormatterStyle? {
        switch self {
        case .email(_): return nil
        case .phone(_): return .phone(lenth: 10)
        }
    }
}

// MARK: - Public meds
public extension LKTwoStepAlertView {

    @discardableResult
    static func alertTwoStepView(title: String?,
                                 twoStepType: LKTwoStepAlertViewType,
                                 showInView viewController: UIViewController,
                                 getCode: (() -> Void)?,
                                 submit: ((String?) -> Void)?) -> LKTwoStepAlertViewController
    {
        let alertView = LKTwoStepAlertView(type: twoStepType, title: title)

        let alertViewController = LKTwoStepAlertViewController(view: alertView)
        alertViewController.showInViewController(viewController, nil)

        alertView.getCodeBlock = getCode
        alertView.submitBlock = submit

        alertView.cancelBlock = { [weak alertViewController] in
            alertViewController?.hidden(nil)
        }

        return alertViewController
    }

}

public class LKTwoStepAlertViewController: LKAlertViewController {

    var twoStepAlertView: LKTwoStepAlertView? { self.customView as? LKTwoStepAlertView }

    public var isCountDown: Bool = false {
        didSet {
            self.twoStepAlertView?.setupCountDown(isCountDown)
        }
    }

    public func updateCodeValidateResult(validateResult: LKTextFieldFormatterView.ValidateResult?) {
        twoStepAlertView?.updateCodeValidateResult(validateResult: validateResult)
    }

    public func cancelCallback(callback : @escaping (() -> Void)) {
        twoStepAlertView?.cancelBlock = callback
    }

}

fileprivate class CodeProxy: CustomTextFieldVaildateProxy {

    static let kStyle: LKCore.LKTextFieldFormatterView.CustomFormatterStyle = .digits(maxLenth: 6, splitLenths: nil, separator: nil)

    required init() {
        super.init(style: CodeProxy.kStyle)
    }

    internal required init(style: LKTextFieldFormatterView.CustomFormatterStyle) { fatalError("init(style:)") }

}

public class LKTwoStepAlertView: UIView {

    var getCodeBlock: (() -> Void)?

    var cancelBlock: (() -> Void)?

    var submitBlock: ((_ code: String?) -> Void)?


    private let title: String?
    
    private let type: LKTwoStepAlertViewType
    
    private let codeProxy = CodeProxy()

    private var getCodeCountDown = kGetCodeCountDownDuration

    private let countDownInterval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance).publish().refCount()

    private var getCodeDisposable: Disposable? {
        didSet {
            oldValue?.dispose()
        }
    }

    private var isActivity: Bool = false {
        didSet {
            self.getCodeButton.isHidden = isActivity
            if isActivity {
                self.activityIndicatorView.startAnimating()
            }else {
                self.activityIndicatorView.stopAnimating()
            }
        }
    }

    private lazy var cancelButton: LKButton = {
        let aBtn = LKButton(style: .borderRed)
        aBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14)
        aBtn.setTitle("Cancel", for: .normal)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        aBtn.setCorner(radius: kActionButtonHeight * 0.5)
        aBtn.addTarget(self, action: #selector(didClickOnCancelButton(_:)), for: .touchUpInside)
        return aBtn
    }()

    private lazy var submitButton: LKButton = {
        let aBtn = LKButton(style: .fillRed)
        aBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14)
        aBtn.setTitle("Submit", for: .normal)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        aBtn.setCorner(radius: kActionButtonHeight * 0.5)
        aBtn.addTarget(self, action: #selector(didClickOnSubmitButton(_:)), for: .touchUpInside)
        return aBtn
    }()

    private lazy var getCodeButton: UIButton = {
        let aBtn = UIButton()
        aBtn.contentHorizontalAlignment = .right
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 12)
        aBtn.setTitleColor(UIColor.lk.text(.hex0475BC), for: .normal)
        aBtn.setTitleColor(UIColor.lk.text(.hex0475BC, alpha: 0.5), for: .highlighted)
        aBtn.setTitleColor(UIColor.lk.text(.hex757575), for: .disabled)
        aBtn.setTitle(kGetCodeText, for: .normal)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        aBtn.addTarget(self, action: #selector(didClickOnGetCodeButton(_:)), for: .touchUpInside)
        return aBtn
    }()

    private lazy var descStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [self.titleLabel, self.valueTextView, self.codeTextView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.distribution = .fill
        aStackView.spacing = 12
        aStackView.setCustomSpacing(12, after: titleLabel)
        return aStackView
    }()

    private lazy var actionsStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [cancelButton, submitButton])
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
        aLabel.text = title
        return aLabel
    }()

    private lazy var valueTextView: LKTextFieldFormatterView = {
        let aTextView = LKTextFieldFormatterView(style: type.textFieldStyle, spacesTuple: (0, 0))
        aTextView.isEditable = type.isEditable
        aTextView.title = type.title
        aTextView.textField.text = type.value
        return aTextView
    }()

    private lazy var codeTextView: LKTextFieldFormatterView = {
        let aTextView = LKTextFieldFormatterView(style: CodeProxy.kStyle, spacesTuple: (36, 12))
        aTextView.textField.delegate = codeProxy
        aTextView.title = "Verification Code"
        aTextView.textField.keyboardType = .numberPad
        aTextView.textField.rightViewMode = .always
        aTextView.textField.rightView = getCodeButton
        aTextView.textField.addTarget(codeProxy, action: codeProxy.editChangedSelector, for: .editingChanged)
        return aTextView
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let aIndicatorView = UIActivityIndicatorView(style: .medium)
        aIndicatorView.hidesWhenStopped = true
        aIndicatorView.color = UIColor.lk.general(.hex757575)
        return aIndicatorView
    }()

    required public init(type: LKTwoStepAlertViewType, title: String?) {
        self.type = type
        self.title = title
        
        super.init(frame: .zero)
        self.backgroundColor = UIColor.lk.general(.hexFFFFFF)
        self.layer.cornerRadius = 16
        self.layer.masksToBounds = true


        if title?.isEmpty ?? true {
            self.descStackView.removeArrangedSubview(titleLabel)
            self.titleLabel.isHidden = true
        }

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

    deinit {
        self.getCodeDisposable?.dispose()
    }

}


// MARK: - Assistant
extension LKTwoStepAlertView {

    private func configure() {
        backgroundColor = UIColor.lk.general(.hexFFFFFF)
    }

    private func setupSubviews() {
        codeTextView.addSubview(activityIndicatorView)

        addSubview(descStackView)
        addSubview(actionsStackView)
    }

    private func setupSubviewsConstraints() {
        activityIndicatorView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalTo(self.codeTextView.textField)
        }

        descStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24).priority(.high)
            make.left.right.equalToSuperview().inset(24)
            make.width.equalTo(kContentMaxWidth)
            make.centerX.equalToSuperview()
        }

        actionsStackView.snp.makeConstraints { (make) in
            make.top.equalTo(descStackView.snp.bottom)
            make.bottom.equalToSuperview().inset(24)
            make.centerX.equalToSuperview()
            make.width.equalTo(kContentMaxWidth)
            make.height.equalTo(kActionButtonHeight)
        }
    }
}

// MARK: - Private meds
extension LKTwoStepAlertView {

    @objc
    private func didClickOnGetCodeButton(_ sender: UIButton) {
        guard sender.isEnabled else { return }
        sender.isEnabled = false

        self.isActivity = true
        self.getCodeBlock?()
    }

    @objc
    private func didClickOnCancelButton(_ sender: UIButton) {
        self.cancelBlock?()
    }

    @objc
    private func didClickOnSubmitButton(_ sender: UIButton) {
        self.submitBlock?(self.codeTextView.textField.text)
    }

}

// MARK: - Public meds
extension LKTwoStepAlertView {

    public func updateCodeValidateResult(validateResult : LKTextFieldFormatterView.ValidateResult?){
        self.codeTextView.validateResult = validateResult
    }

    /// 配置是否启动倒计时
    /// - Parameter isCountDown: 是否开启倒计时
    public func setupCountDown(_ isCountDown: Bool) {
        func stop() {
            defer { self.isActivity = false }
            self.getCodeDisposable?.dispose()
            self.getCodeButton.isEnabled = true
            self.getCodeButton.sizeToFit()
        }

        if isCountDown {
            self.getCodeCountDown = kGetCodeCountDownDuration
                        
            self.getCodeDisposable = self.countDownInterval.observe(on: MainScheduler.asyncInstance).subscribe(onNext: { [weak self]  _ in
                defer { self?.isActivity = false }

                self?.getCodeCountDown -= 1

                switch self?.getCodeCountDown ?? 0 {
                case 1 ..< kGetCodeCountDownDuration:
                    self?.getCodeButton.isEnabled = false
                    self?.getCodeButton.setTitle("\(self?.getCodeCountDown ?? 0) s", for: .disabled)
                default: stop()
                }
            })
        }else {
            stop()
        }
    }

}
