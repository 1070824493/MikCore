//
//  MikNumberTextView.swift
//  MikCore
//
//  Created by gaowei on 2021/4/21.
//

import UIKit
import SnapKit
import RxSwift

public class MikNumberTextView: UIView {
    
    public var takeTextEndEditingBlock: ((_ text: String) -> ())?
    
    /// 是否输入价格
    public var isInputPrice: Bool = false {
        didSet {
            self.textField.text = self.isInputPrice ? "$" : nil
        }
    }
    
    /// 最大输入字数，默认为0，没有限制
    public var maxInputWords = 0
    /// 输入最小数
    public var minNumber: String?
    /// 输入最大数
    public var maxNumber: String?
    
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
    
    /// 输入框文本
    public var text: String? {
        get {
            return self.textField.text!.trimmingCharacters( in : .whitespaces)
        }
        set {
            self.textField.text = newValue
            self.inputArray.removeAll()
            self.textField.text?.forEach({ s in
                self.inputArray.append(String(s))
            })
        }
    }
    public var placeholder: String? {
        didSet {
            self.textField.placeholder = placeholder
        }
    }
    /// 输入框背景色
    public var textBackgroundColor: UIColor = .white {
        didSet {
            self.textField.backgroundColor = textBackgroundColor
        }
    }
    public var borderColor: CGColor? {
        didSet {
            self.textField.layer.borderColor = self.borderColor
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
    //对齐方式
    public var textAlignment: NSTextAlignment {
        get {self.textField.textAlignment }
        set {
            self.textField.textAlignment = newValue
        }
    }
    public var FieldHeight:CGFloat {
        
        set {
            textField.snp.remakeConstraints { (make) in
                make.left.right.equalToSuperview()
                make.height.equalTo(newValue)
            }
        }
        get {
            return textField.frame.height
        }
    }
    
    public var textFont:UIFont? {
        didSet {
            textField.font = textFont
        }
    }
 
    /// 输入数组，每输入一个字符添加到此数组
    lazy private var inputArray: [String] = {
       return [String]()
    }()
    
    lazy private var titleLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.mik.font(size: 12.rate)
        label.textColor = UIColor.mik.text(.hex1B1B1B)
        label.text = "First Name*"
        
        return label
    }()
    
    lazy private var textField: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.mik.font(size: 16.rate)
        textField.textColor = UIColor.mik.text(.hex1B1B1B)
        textField.textAlignment = .left
        textField.keyboardType = .numberPad
        textField.autocorrectionType = .no // 关闭联想
        textField.autocapitalizationType = .none // 关闭首字母大写
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        textField.layer.borderWidth = 1.0
        textField.layer.borderColor = UIColor.mik.general(.hexAEAEAE).cgColor
        textField.layer.cornerRadius = 4.rate
        textField.leftViewMode = .always
        textField.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 12.rate, height: 48.rate))
        
        return textField
    }()
    
    lazy private var messageLab: UILabel = {
        let label = UILabel()
        label.font = UIFont.mik.font(size: 12.rate)
        label.textColor = UIColor.mik.text(.hex1B1B1B)
        label.text = "Select the category that defines your product."
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
   
        let stackView = UIStackView.init(arrangedSubviews: [ titleLab, textField, messageLab ])
        stackView.axis = .vertical
        stackView.spacing = 4.rate
        stackView.distribution = .fill
        stackView.alignment = .lastBaseline
        stackView.isLayoutMarginsRelativeArrangement = true
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        titleLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(12.rate)
        }
        textField.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(48.rate)
        }
        messageLab.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(12.rate)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MikNumberTextView: UITextFieldDelegate {
    
    @objc private func textFieldDidChange(textField: UITextField) {
        if self.maxInputWords > 0  {
            if textField.text?.count ?? 0 >= self.maxInputWords {
                if let str = textField.text {
                    //截取前最大字符
                    if self.isInputPrice {
                        self.removeInputPrice()
                    } else {
                        textField.text = String(str.prefix(self.maxInputWords))
                    }
                }
            }
        }
        
        if !self.isInputPrice {
            if textField.text?.count ?? 0 > 0 {
                let text = textField.text!
                if text.first == "0" {
                    let index = text.index(text.startIndex, offsetBy: 1)
                    textField.text = String(text[index...])
                }
            }
        }
    }
    
    private func removeInputPrice() {
        guard self.isInputPrice else { return }
        
        if self.inputArray.count > self.maxInputWords + 1 {
            self.inputArray.removeAll { (str) -> Bool in
                return (str == "$" || str == "." || str == ",") ? true : false
            }
            let maxValue = self.maxInputWords - 1
            if self.inputArray.indices ~= maxValue {
                self.inputArray.removeSubrange(maxValue...(self.inputArray.count - 1))
            }
            self.inputArray.insert("$", at: 0)
            self.inputArray.insert(".", at: self.inputArray.count - 2)
            self.textField.text = self.inputArray.joined()
        }
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !self.isInputPrice {
            if !string.isEmpty ,!MikValidateRegex.isNumber(string).isRight {
                return false
            }
            return true
        }
        
        if self.inputArray.count == 0  {
            for t in self.textField.text ?? "" {
                self.inputArray.append(String(t))
            }
        }
        
        if string == "" {
            if let rang1 = Range(range), range.length + range.location <= self.inputArray.count {
                self.inputArray.removeSubrange(rang1)
            } else {
                return false;
            }
        } else {
            if (self.inputArray.count == 0 || range.location <= 1) && string == "0" {
                return false
            }
            if !MikValidateRegex.isNumber(string).isRight {
                return false
            }
            var stringList : [String] = []
            var zeroIndex = 0
            for str in string {
                let numStr = String(str)
                stringList.append(numStr)
                if numStr == "0" {
                    zeroIndex += 1
                }
            }
            
            if self.textField.text == "$0.00" , zeroIndex == stringList.count {
                return false
            }
            if self.inputArray.count == 0  {
                for t in self.textField.text ?? "" {
                    self.inputArray.append(String(t))
                }
            }
            if range.location + range.length >= textField.text!.count {
                if range.location == 0 , range.location + range.length == textField.text!.count {
                    self.inputArray.removeAll()
                    self.inputArray += stringList
                }else{
                    self.inputArray += stringList
                }
                
            } else {
                if let r = Range(range) {
                    self.inputArray.replaceSubrange(r, with: stringList)
                }
                
            }
        }
        
        self.inputArray.removeAll { (str) -> Bool in
            return (str == "$" || str == "." || str == ",") ? true : false
        }
        var index : Int?
        for (i, item) in inputArray.enumerated() {
            if item == "0" {
                index = i
            } else {
                break
            }
        }
        if let i = index , i + 1 <= self.inputArray.count {
            self.inputArray.removeSubrange(Range<Int>(NSRange(location: 0, length: i + 1))!)
        }
        
        if self.inputArray.count == 0 {
            textField.text = "$"
        } else {
            var text = self.inputArray.joined()
            if text.count == 1 {
                textField.text = "$0.0" + text
            } else if text.count == 2 {
                textField.text = "$0." + text
            } else {
                text.insert(".", at: text.index(text.endIndex, offsetBy: -2))
                text.insert("$", at: text.startIndex)
                textField.text = text
            }
        }
        self.inputArray.removeAll()
        for text in textField.text! {
            self.inputArray.append(String(text))
        }
        self.removeInputPrice()
        return false
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        if var text = textField.text, text.count > 0  {
            text.removeAll(where: { $0 == "$" })
            
            if let number = minNumber, Float(text)! < Float(number)! {
                if isInputPrice {
                    textField.text = "$" + number
                } else {
                    textField.text = number
                }
            }
            if let number = maxNumber, Float(text)! > Float(number)! {
                if isInputPrice {
                    textField.text = "$" + number
                } else {
                    textField.text = number
                }
            }
        }
        
        self.takeTextEndEditingBlock?(textField.text!)
    }
}


// MARK: - 公开方法
public extension MikNumberTextView {
    
    func setMessage(_ message: String, isError: Bool) {
        if message.count == 0 {
            return
        }
        if self.messageLab.isHidden {
            self.messageLab.isHidden = false
        }
        
        if isError {
            self.titleLab.textColor = UIColor.mik.text(.hexCF1F2E)
            self.textField.layer.borderColor = UIColor.mik.general(.hexAEAEAE).cgColor
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.mik.text(.hexCF1F2E), .font : UIFont.mik.font(size: 12.rate) ]
            let att = NSMutableAttributedString.init(string: "  " + message, attributes: attributes)
            let attImage = NSTextAttachment()
            attImage.image = UIImage.image("mik_alert_circle")?.withTintColor(UIColor.mik.general(.hexEB003B))
            attImage.bounds = CGRect.init(x: 0, y: -4.rate, width: 18.rate, height: 18.rate)
            att.insert(NSAttributedString.init(attachment: attImage), at: 0)
            self.messageLab.attributedText = att
            
        } else {
            
            self.titleLab.textColor = UIColor.mik.text(.hex1B1B1B)
            self.textField.layer.borderColor = UIColor.mik.general(.hexAEAEAE).cgColor
            
            let attributes: [NSAttributedString.Key : Any] = [.foregroundColor: UIColor.mik.text(.hex1B1B1B), .font : UIFont.mik.font(size: 12.rate) ]
            self.messageLab.attributedText = NSAttributedString.init(string: message, attributes: attributes)
        }
    }
    
}
