//
//  MikTextFieldFormatterView.swift
//  MikCore
//
//  Created by m7 on 2021/9/2.
//
//  支持输入格式化、显示校验结果的 UI 组件
//  注：取值用‘self.textField.text_’, 'text_' 简单的去除了格式化字符
//     ‘self.textField.rx.text_’ 替代了 'self.textField.rx.text'

import UIKit
import SnapKit

public extension MikTextFieldFormatterView {
    
    typealias SpacesTuple = (max: CGFloat, min: CGFloat)
    
    // 校验结果
    enum ValidateResult: Equatable {
        case tips(msg: String?), ok(msg: String?), error(msg: String?)
        
        public static func == (lhs: ValidateResult, rhs: ValidateResult) -> Bool {
            switch (lhs, rhs) {
            case (.tips(let lMsg), .tips(let rMsg)): return lMsg == rMsg
            case (.ok(let lMsg), .ok(let rMsg)): return lMsg == rMsg
            case (.error(let lMsg), .error(let rMsg)): return lMsg == rMsg
            default: return false
            }
        }
    }
    
    // 常用自定义格式化样式
    enum CustomFormatterStyle {
        case phone(lenth: Int)
        case digits(maxLenth: Int?, splitLenths: [Int]?, separator: Character?)
        
        var formatteTuple: MikFormatterTextField.FormatterTuple? {
            switch self {
            case .phone(10): return ([3, 3, 4], "-")
            case .phone(11): return ([3, 4, 4], "-")
            case .digits(_, let splitLenths, let separator):
                if let splitLenths = splitLenths, !splitLenths.isEmpty, let separator = separator {
                    return (splitLenths, separator)
                }
                return nil
            default: return nil
            }
        }
    }
    
        
    var textField: MikFormatterTextField { self.textFieldView.textField }
    
}


// MARK: - extensions
fileprivate extension MikTextFieldFormatterView.ValidateResult {
    
    var isSuccess: Bool? {
        switch self {
        case .tips(_): return nil
        case .ok(_): return true
        case .error(_): return false
        }
    }
    
    var attributeMessage: NSAttributedString {
        let iconImage: UIImage?
        let message: String?
        let tinColor: UIColor
        
        switch self {
        case .tips(let msg):
            message = msg
            iconImage = nil
            tinColor = UIColor.mik.general(.hex1B1B1B)
        case .error(let msg):
            message = "  \(msg ?? "")"
            iconImage = UIImage.image("mik_text_error")
            tinColor = UIColor.mik.general(.hexEB003B)
        case .ok(let msg):
            message = "  \(msg ?? "")"
            iconImage = UIImage.image("mik_text_success")
            tinColor = UIColor.mik.general(.hex00856D)
        }
        
        let mAttribute = NSMutableAttributedString()
        
        if let iconImage = iconImage {
            let iconArrtibute = NSAttributedString(attachment: {
                let attachment = NSTextAttachment()
                attachment.image = iconImage.withTintColor(tinColor)
                attachment.bounds = CGRect(x: 0, y: -3, width: 14, height: 14)
                return attachment
            }())
            mAttribute.append(iconArrtibute)
        }
        
        if let message = message {
            let msgAttribute = NSAttributedString(string: "\(message)", attributes: [.font : UIFont.mik.font(size: 12), .foregroundColor : tinColor])
            mAttribute.append(msgAttribute)
        }
        
        return mAttribute
    }
    
}

public class MikTextFieldFormatterView: UIView {

    /// 标题
    public var title: String? {
        didSet {
            self.titleView.titleLabel.text = title
            self.setupStackArrangedSubviews()
        }
    }
    
    /// 校验结果
    public var validateResult: ValidateResult? {
        didSet {
            self.validateResults = {
                guard let validateResult = validateResult else { return nil }
                return [validateResult]
            }()
        }
    }
    
    /// 校验结果集
    public var validateResults: [ValidateResult]? {
        didSet {
            self.updateValidateResults(validateResults)
        }
    }
    
    /// 是否可编辑
    public var isEditable: Bool = true {
        didSet {
            self.textField.isEnabled = isEditable
            self.textField.textColor = isEditable ? UIColor.mik.text(.hex1B1B1B) : UIColor.mik.text(.hex757575)
            self.textField.backgroundColor = isEditable ? UIColor.mik.general(.hexFFFFFF) : UIColor.mik.general(.hexF6F6F6)
        }
    }
    
    private let formatteTuple: MikFormatterTextField.FormatterTuple?
    
    private let spacesTuple: SpacesTuple
    
    private var isEditing: Bool = false {
        didSet {
            self.updateValidateResults(self.validateResults)
        }
    }
       
    
    private lazy var titleView: TitleView = TitleView()
    
    private lazy var textFieldView: TextFieldView = {
        let aView = TextFieldView(formatteTuple: formatteTuple)
        aView.textField.addTarget(self, action: #selector(didBeginEditing(_:)), for: .editingDidBegin)
        aView.textField.addTarget(self, action: #selector(didEndEditing(_:)), for: .editingDidEnd)
        return aView
    }()
    
    private lazy var validateView: ValidateView = ValidateView()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [textFieldView, validateView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 0
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    
    /// 初始化器
    /// - Parameters:
    ///   - formatteTuple: 输入格式化配置
    ///   - spacesTuple: 底部间距配置, 默认为 (28, 4)
    required public init(formatteTuple: MikFormatterTextField.FormatterTuple?, spacesTuple: SpacesTuple = (28, 4)) {
        self.formatteTuple = formatteTuple
        self.spacesTuple = spacesTuple
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    /// 便利构造器
    /// - Parameters:
    ///   - style: 样式
    ///   - spacesTuple: 底部间距配置, 默认为 (28, 4)
    convenience public init(style: CustomFormatterStyle?, spacesTuple: SpacesTuple = (28, 4)) {
        self.init(formatteTuple: style?.formatteTuple, spacesTuple: spacesTuple)
    }
    
    private override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
}

// MARK: - Assistant
extension MikTextFieldFormatterView {
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
    }
    
    private func setupSubviews() {
        addSubview(mStackView)
    }
    
    private func setupSubviewsConstraints() {
        mStackView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(spacesTuple.min)
        }
        
        validateView.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(max(spacesTuple.max - spacesTuple.min, 0))
        }
    }
    
    private func setupStackArrangedSubviews() {
        if let title = title, !title.isEmpty {
            if !mStackView.arrangedSubviews.contains(titleView) {
                mStackView.insertArrangedSubview(titleView, at: 0)
            }
        }else {
            if mStackView.arrangedSubviews.contains(titleView) {
                mStackView.mik.removeArrangedSubviewCompletely(titleView)
            }
        }
    }       
    
}

// MARK: - Private
extension MikTextFieldFormatterView {
        
    private func updateValidateResults(_ validateResults: [ValidateResult]?) {
        let bValidateResults: [ValidateResult]? = {
            if self.isEditing {
                // 编辑状态下只允许显示‘Tip’
                return validateResults?.compactMap({
                    switch $0 {
                    case .tips(_): return $0
                    default: return nil
                    }
                })
            }
            return validateResults
        }()
        
        self.validateView.validateResults = bValidateResults
        self.textFieldView.style = {
            guard let bValidateResults = bValidateResults, !bValidateResults.isEmpty else {
                return .normal
            }
            
            if let _ = bValidateResults.first(where: { !($0.isSuccess ?? true) }) {
                return .error
            }
            
            if let _ = bValidateResults.first(where: { $0.isSuccess ?? false }) {
                return .ok
            }
            
            return .normal
        }()
    }
    
    @objc
    private func didBeginEditing(_ sender: UITextField) {
        self.isEditing = true
    }
    
    @objc
    private func didEndEditing(_ sender: UITextField) {
        self.isEditing = false
    }
    
}

// MARK: - TitleView
fileprivate class TitleView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.nunitoSans, size: 12)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
        return aLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 16, bottom: 6, right: 0))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

fileprivate extension TextFieldView.Style {
    
    var borderColor: UIColor {
        switch self {
        case .normal: return UIColor.mik.general(.hexAEAEAE)
        case .ok: return UIColor.mik.general(.hex00856D)
        case .error: return UIColor.mik.general(.hexEB003B)
        }
    }
    
}

// MARK: - TextFieldView
fileprivate class TextFieldView: UIView {
    
    enum Style {
        case normal, ok, error
    }
    
    var style: Style = .normal {
        didSet {
            self.layer.borderColor = style.borderColor.cgColor
            textField.layer.borderColor = style.borderColor.cgColor
        }
    }
    
    private let formatteTuple: MikFormatterTextField.FormatterTuple?
    
    private(set) lazy var textField: MikFormatterTextField = {
        let aTextField = MikFormatterTextField(formatteTuple: formatteTuple)
        aTextField.font = UIFont.mik.font(size: 16)
        aTextField.textColor = UIColor.mik.text(.hex1B1B1B)
        aTextField.leftViewMode = .always
        aTextField.rightViewMode = .always
        aTextField.autocorrectionType = .no
        aTextField.setupLeftEmptyView()
        aTextField.setupRightEmptyView()
        return aTextField
    }()
    
    
    required init(formatteTuple: MikFormatterTextField.FormatterTuple?) {
        self.formatteTuple = formatteTuple
        super.init(frame: .zero)
        
        layer.cornerRadius = 4
        layer.borderWidth = 1
        layer.borderColor = style.borderColor.cgColor
        textField.layer.borderColor = style.borderColor.cgColor
        layer.masksToBounds = true
        
        addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(48.rate)
        }
    }
    
    private override init(frame: CGRect) {
       fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - ValidateView
fileprivate class ValidateView: UIView {
    
    var validateResults: [MikTextFieldFormatterView.ValidateResult]? {
        didSet {
            guard validateResults != oldValue else { return }
                        
            self.titleLabel.attributedText = {
                guard let validateResults = validateResults, !validateResults.isEmpty else { return nil }
                
                let bAttributeMessages = NSMutableAttributedString()
                validateResults.enumerated().forEach({
                    if $0 != 0 { bAttributeMessages.append(NSAttributedString(string: "\n")) }
                    bAttributeMessages.append($1.attributeMessage)
                })
                return bAttributeMessages
            }()
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.nunitoSans, size: 12)
        aLabel.textColor = UIColor.mik.text(.hexEB003B)
        aLabel.preferredMaxLayoutWidth = UIScreen.main.bounds.width - 100
        aLabel.numberOfLines = 0
        aLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        aLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return aLabel
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(4)
            make.left.equalToSuperview().inset(16)
            make.right.lessThanOrEqualToSuperview().inset(16).priority(.high)
            make.bottom.lessThanOrEqualToSuperview().priority(.high)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let maxLayoutWidth = rect.size.width - 32
        if titleLabel.preferredMaxLayoutWidth != maxLayoutWidth {
            titleLabel.preferredMaxLayoutWidth = maxLayoutWidth
        }
    }
    
}


