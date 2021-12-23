//
//  MikTextViewCell.swift
//  MikMobile
//
//  Created by gaowei on 2021/3/23.
//

import UIKit
import SnapKit
import RxSwift

/// 视图风格
public enum MikTextViewStyle {
    /// 默认
    case `default`
    /// 成功
    case success
    /// 错误
    case error
}

open class MikTextViewCell: UIView {
    
    /// 全局按钮回调
    public var takeFullActionBlock: ((_ text: String) -> ())?
    /// 右侧按钮回调
    public var takeRightActionBlock: ((_ text: String) -> ())?
    /// 左侧按钮回调
    public var takeLeftActionBlock: ((_ text: String) -> ())?
    /// 输入完成回调
    public var takeTextEndEditingBlock: ((_ text: String) -> ())?
    /// 输入状态改变回调
    public var takeTextDidChangeBlock: ((_ textViewCell: MikTextViewCell, _ text: String) -> ())?
    
    /// 全局按钮输出流
    public lazy var outputFullAction: PublishSubject<String?> = {
        return PublishSubject()
    }()
    /// 右侧按钮输出流
    public lazy var outputRightAction: PublishSubject<String?> = {
        return PublishSubject()
    }()
    /// 左侧按钮输出流
    public lazy var outputLeftAction: PublishSubject<String?> = {
        return PublishSubject()
    }()
    /// 文本框输出流
    public lazy var outputTextEndEditing: PublishSubject<String?> = {
        return PublishSubject()
    }()
    /// 文本框状态改变输出流
    public lazy var outputTextDidChange: PublishSubject<(MikTextViewCell, String?)> = {
        return PublishSubject()
    }()
    
    /// 最大输入字数，默认为0，没有限制
    public var maxInputWords = 0
    /// 是否修剪前后空格，默认修剪
    public var isTrimmingCharacters = true
    /// 是否支持换行，默认支持
    public var isNext = true {
        didSet {
            self.textField.isHidden = isNext
            self.textView.isHidden = !isNext
        }
    }
    /// 禁止输入字符
    public var disableInputs: [String]?
    
    /// 可设置输入框默认高度
    public var defaultTextViewHeight: CGFloat = 48.rate {
        didSet {
            self.textView.snp.remakeConstraints { (make) in
                make.height.equalTo(defaultTextViewHeight)
            }
            self.textField.snp.remakeConstraints { (make) in
                make.height.equalTo(defaultTextViewHeight)
            }
        }
    }
    
    /// 可设置输入框最大高度
    public var maxTextViewHeight: CGFloat = 134.rate
    
    /// 标题文本
    public var title: String? {
        get {
            return titleLab.text
        }
        set(newValue) {
            self.titleLab.text = newValue
        }
    }
    //title font
    public var titleFont: UIFont? {
        didSet {
            self.titleLab.font = self.titleFont
        }
    }
    //title color
    public var titleColor: UIColor? {
        didSet {
            self.titleLab.textColor = self.titleColor
        }
    }
    
    public var titleMargin: (CGFloat, CGFloat)? {
        didSet {
            self.titleLab.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().inset(self.titleMargin?.0 ?? 16.rate)
                make.right.equalToSuperview().inset(self.titleMargin?.1 ?? 16.rate)
            }
        }
    }
    
    /// 输入框文本
    public var text: String? {
        get {
            var value: String = ""
            if isNext {
                value = textView.text
            } else {
                value = textField.text ?? ""
            }
            if self.isTrimmingCharacters {
                return value.trimmingCharacters( in : .whitespaces)
            } else {
                return value
            }
        }
        set {
            if isNext {
                
                if newValue == self.textView.text {
                    return
                }
                self.textView.text = newValue
                placeholderLabel.isHidden = (newValue?.isEmpty ?? true)  ? false : true
                self.textView.isScrollEnabled = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    var textHeight = self.textView.sizeThatFits(CGSize.init(width: self.textView.bounds.size.width, height: CGFloat(MAXFLOAT))).height
                    if textHeight > self.maxTextViewHeight {
                        textHeight = self.maxTextViewHeight
                    }
                    
                    if textHeight != self.textView.bounds.height {
                        if textHeight < self.defaultTextViewHeight {
                            textHeight = self.defaultTextViewHeight
                        }
                        self.textView.snp.updateConstraints { (make) in
                            make.height.equalTo(textHeight)
                        }
                    }
                    self.textView.isScrollEnabled = true
                }
                
            } else {
                self.textField.text = newValue
            }
            
        }
    }
    /// 输入框文本颜色
    public var textColor: UIColor? {
        didSet {
            self.textView.textColor = self.textColor
            self.textField.textColor = self.textColor
        }
    }
    
    /// 返回键类型
    public var returnKeyType: UIReturnKeyType = .default {
        didSet {
            self.textView.returnKeyType = returnKeyType
            self.textField.returnKeyType = returnKeyType
        }
    }
    /// 键盘类型
    public var keyboardType: UIKeyboardType = .default {
        didSet {
            self.textView.keyboardType = keyboardType
            self.textField.keyboardType = keyboardType
        }
    }
    /// 文本框是否可输入
    public var textUserInteractionEnabled: Bool = true {
        didSet {
            self.textView.isUserInteractionEnabled = textUserInteractionEnabled
            self.textField.isUserInteractionEnabled = textUserInteractionEnabled
        }
    }
    
    /// 输入框背景色
    public var textBackgroundColor: UIColor = .white {
        didSet {
            self.bgTextView.backgroundColor = textBackgroundColor
            self.textView.backgroundColor = textBackgroundColor
            self.textField.backgroundColor = textBackgroundColor
        }
    }
    public var placeholder: String? {
        didSet {
            self.placeholderLabel.text = self.placeholder
            self.setupTextFiledPlaceholder()
        }
    }
    public var placeholderColor: UIColor? {
        didSet {
            self.placeholderLabel.textColor = self.placeholderColor
            self.setupTextFiledPlaceholder()
        }
    }
   
    public var borderColor: CGColor? {
        didSet {
            self.bgTextView.layer.borderColor = self.borderColor
        }
    }
    public var borderWidth: CGFloat? {
        didSet {
            self.bgTextView.layer.borderWidth = self.borderWidth ?? 1.0
        }
    }
    /// 描述文本
    public var message: String? {
        get {
            return self.messageLab.text
        }
        set(newValue) {
            self.messageLab.text = newValue
        }
    }
    public var messageMargin: (CGFloat, CGFloat)? {
        didSet {
            self.messageLab.snp.remakeConstraints { (make) in
                make.left.equalToSuperview().inset(self.messageMargin?.0 ?? 16.rate)
                make.right.equalToSuperview().inset(self.messageMargin?.1 ?? 16.rate)
            }
        }
    }
    
    /// 右侧图标
    public var rightImage: UIImage? {
        get {
            return self.rightButton.currentImage
        }
        set(newValue) {
            self.rightButton.setImage(newValue, for: .normal)
        }
    }
    public var leftImage : UIImage? {
        get {
            return self.leftButton.currentImage
        }
        set(newValue){
            self.leftButton.setImage(newValue, for: .normal)
        }
    }
    /// 是否隐藏标题
    public var isHiddenTitle: Bool = false {
        didSet {
            self.titleLab.isHidden = isHiddenTitle
        }
    }
    /// 是否隐藏说明
    public var isHiddenMessage: Bool = false {
        didSet {
            self.messageLab.isHidden = isHiddenMessage
        }
    }
    /// 是否隐藏全局按钮
    public var isHiddenFullButton: Bool = false {
        didSet {
            self.button.isHidden = isHiddenFullButton
        }
    }
    /// 是否隐藏右侧按钮
    public var isHiddenRightButton: Bool = false {
        didSet {
            self.rightButton.isHidden = isHiddenRightButton
        }
    }
    
    /// 是否隐藏左侧按钮
    public var isHiddenLeftButton : Bool = true{
        didSet{
            self.leftButton.isHidden = isHiddenLeftButton
        }
    }
    
    lazy private var titleLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.mik.font(size: 12.rate)
        label.textColor = UIColor.mik.text(.hex1B1B1B)
        label.text = "First Name*"
        
        return label
    }()
    
    lazy private var messageLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.mik.font(size: 12.rate)
        label.textColor = UIColor.mik.text(.hex1B1B1B)
        label.text = "Select the category that defines your product."
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy private var bgTextView: UIView = {
        let bgView = UIView()
        bgView.layer.cornerRadius = 4.rate
        bgView.layer.borderWidth = 1.0
        bgView.layer.borderColor = UIColor.mik.general(.hex1B1B1B).cgColor
        return bgView
    }()
    
    lazy private var placeholderLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.mik.font(.nunitoSans, size: 16)
        label.textColor = UIColor.mik.text(.hex757575)
        label.numberOfLines = 1
        return label
    }()
    
    lazy private var textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.mik.font(.nunitoSans, size: 16.rate)
        textView.textColor = UIColor.mik.text(.hex1B1B1B)
        textView.delegate = self
        textView.scrollsToTop = false
        textView.autocorrectionType = .no // 关闭联想
        textView.autocapitalizationType = .none // 关闭首字母大写
        let margin = (defaultTextViewHeight-25)/2
        textView.textContainerInset = UIEdgeInsets.init(top: margin, left: 0, bottom: margin, right: 0)
        textView.textContainer.lineFragmentPadding = 0
        textView.isHidden = !self.isNext
        return textView
    }()
    
    lazy private var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.mik.font(.nunitoSans, size: 16.rate)
        textField.textColor = UIColor.mik.text(.hex1B1B1B)
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField.delegate = self
        textField.isHidden = self.isNext
        return textField
    }()
    
    lazy private var rightButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.image("arrow_down"), for: .normal)
        button.addTarget(self, action: #selector(rightBtnAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    lazy private var leftButton : UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.image("arrow_down"), for: .normal)
        button.addTarget(self, action: #selector(leftBtnAction), for: UIControl.Event.touchUpInside)
        button.isUserInteractionEnabled = false
        button.isHidden = true
        return button
    }()
    
    lazy private var button: UIButton = {
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(selectBtnAction), for: UIControl.Event.touchUpInside)
        return button
    }()
    
    
// MARK: - init
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        let stackView = UIStackView.init(arrangedSubviews: [ titleLab, bgTextView, messageLab ])
        stackView.axis = .vertical
        stackView.spacing = 4.rate
        stackView.alignment = .lastBaseline
        stackView.distribution = .fill
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16.rate)
        }
        bgTextView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.greaterThanOrEqualTo(defaultTextViewHeight)
        }
        messageLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16.rate)
        }

        let textStackView = UIStackView.init(arrangedSubviews: [leftButton, textView, textField, rightButton])
        textStackView.axis = .horizontal
        textStackView.alignment = .center
        textStackView.distribution = .fill
        textStackView.spacing = 16.rate
        bgTextView.addSubview(textStackView)
        textStackView.snp.makeConstraints { (make) in
            make.left.equalTo(stackView.snp.left).inset(16.rate)
            make.right.equalTo(stackView.snp.right).inset(16.rate)
            make.top.bottom.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.size.equalTo(21.rate)
        }
        rightButton.snp.makeConstraints { (make) in
            make.size.equalTo(21.rate)
        }
        textView.snp.makeConstraints { (make) in
            make.height.equalTo(defaultTextViewHeight)
        }
        textField.snp.makeConstraints { (make) in
            make.height.equalTo(defaultTextViewHeight)
        }
        
        bgTextView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(stackView.snp.left)
            make.right.equalTo(stackView.snp.right)
            make.top.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        textView.insertSubview(placeholderLabel, at: 0)
        placeholderLabel.snp.remakeConstraints { (maker) in
            maker.left.equalToSuperview().offset(textView.textContainerInset.left + 4.rate)
            maker.top.equalToSuperview().offset(textView.textContainerInset.top)
        }
    }
    
    private func setupTextFiledPlaceholder() {
        guard let color = placeholderColor else {
            self.textField.placeholder = self.placeholder
            return
        }
        self.textField.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 点击事件
extension MikTextViewCell {
    @objc private func selectBtnAction() {
        let value: String = self.text ?? ""
        self.takeFullActionBlock?(value)
        
        self.outputFullAction.onNext(value)
    }
    
    @objc private func rightBtnAction() {
        let value: String = self.text ?? ""
        self.takeRightActionBlock?(value)
        self.outputRightAction.onNext(value)
    }
    @objc private func leftBtnAction(){
        let value: String = self.text ?? ""
        self.takeLeftActionBlock?(value)
        self.outputLeftAction.onNext(value)
    }
}


extension MikTextViewCell: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if let disableInputs = disableInputs, disableInputs.count > 0 {
            let matches = disableInputs.map { item in
                return "^(?!.*\(item))"
            }
            let predicate = NSPredicate.init(format: "SELF MATCHES %@", "(\(matches.joined())).*$")
            return predicate.evaluate(with: text)
        }
        
        return true
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        
        if self.maxInputWords > 0  {
            if textView.text.count > self.maxInputWords, let str = textView.text {
                //截取前最大字符
                textView.text = String(str.prefix(self.maxInputWords))
            }
        }
        
        var textHeight = textView.sizeThatFits(CGSize.init(width: textView.bounds.size.width, height: CGFloat(MAXFLOAT))).height
        if textHeight > maxTextViewHeight {
            textHeight = maxTextViewHeight
        }
        
        if textHeight != textView.bounds.height {
            if textHeight < defaultTextViewHeight {
                textHeight = defaultTextViewHeight
            }
            textView.snp.updateConstraints { (make) in
                make.height.equalTo(textHeight)
            }
        }
        
        self.placeholderLabel.isHidden = textView.text.isEmpty ? false : true
        self.takeTextDidChangeBlock?(self, textView.text)
        self.outputTextDidChange.onNext((self, textView.text))
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        if self.isTrimmingCharacters {
            let text = textView.text.trimmingCharacters( in : .whitespaces)
            self.takeTextEndEditingBlock?(text)
            
            self.outputTextEndEditing.onNext(text)
            
        } else {
            self.takeTextEndEditingBlock?(textView.text)
            
            self.outputTextEndEditing.onNext(textView.text)
        }
    }
    
}

extension MikTextViewCell: UITextFieldDelegate {
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "\n" {
            textField.resignFirstResponder()
            return false
        }
        
        if let disableInputs = disableInputs, disableInputs.count > 0 {
            let matches = disableInputs.map { item in
                return "^(?!.*\(item))"
            }
            let predicate = NSPredicate.init(format: "SELF MATCHES %@", "(\(matches.joined())).*$")
            return predicate.evaluate(with: string)
        }
        
        return true
    }
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if self.isTrimmingCharacters {
            let text = textField.text?.trimmingCharacters( in : .whitespaces) ?? ""
            self.takeTextEndEditingBlock?(text)
            
            self.outputTextEndEditing.onNext(text)
            
        } else {
            self.takeTextEndEditingBlock?(textField.text ?? "")
            
            self.outputTextEndEditing.onNext(textField.text)
        }
    }
    @objc private func textFieldDidChange(textField: UITextField) {
        if self.maxInputWords > 0  {
            if (textField.text?.count ?? 0) > self.maxInputWords, let str = textField.text {
                //截取前最大字符
                textField.text = String(str.prefix(self.maxInputWords))
            }
        }
        self.takeTextDidChangeBlock?(self, textField.text ?? "")
        self.outputTextDidChange.onNext((self, textField.text))
    }
    
}


// MARK: - 公开方法
public extension MikTextViewCell {
    
    /// 设置说明状态
    func setMessage(_ message: String, style: MikTextViewStyle = .default) {
        if message.count == 0 {
            return
        }
        if self.messageLab.isHidden {
            self.messageLab.isHidden = false
        }
        
        switch style {
        case .default:
            self.titleLab.textColor = UIColor.mik.text(.hex1B1B1B)
            self.bgTextView.layer.borderColor = UIColor.mik.general(.hex1B1B1B).cgColor
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.mik.text(.hex1B1B1B),
                                                              .font : UIFont.mik.font(size: 12.rate) ]
            self.messageLab.attributedText = NSAttributedString.init(string: message, attributes: attributes)
            
        case .success:
            self.titleLab.textColor = UIColor.mik.text(.hex009783)
            self.bgTextView.layer.borderColor = UIColor.mik.general(.hex009783).cgColor
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.mik.text(.hex009783),
                                                              .font : UIFont.mik.font(size: 12.rate) ]
            let att = NSMutableAttributedString.init(string: "  " + message, attributes: attributes)
            let attImage = NSTextAttachment()
            attImage.image = UIImage.image("mik_text_success")?.withTintColor(UIColor.mik.general(.hex009783))
            attImage.bounds = CGRect.init(x: 0, y: -3, width: 14, height: 14)
            att.insert(NSAttributedString.init(attachment: attImage), at: 0)
            self.messageLab.attributedText = att
            
        default:
            self.titleLab.textColor = UIColor.mik.text(.hex1B1B1B)
            self.bgTextView.layer.borderColor = UIColor.mik.general(.hexEB003B).cgColor
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.mik.text(.hexEB003B),
                                                              .font : UIFont.mik.font(size: 12.rate) ]
            let att = NSMutableAttributedString.init(string: "  " + message, attributes: attributes)
            let attImage = NSTextAttachment()
            attImage.image = UIImage.image("mik_text_error")?.withTintColor(UIColor.mik.general(.hexEB003B))
            attImage.bounds = CGRect.init(x: 0, y: -3, width: 14, height: 14)
            att.insert(NSAttributedString.init(attachment: attImage), at: 0)
            self.messageLab.attributedText = att
            
        }
    }
    
}

