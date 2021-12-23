//
//  MikTextFieldCustomDelegate.swift
//  MikCore
//
//  Created by m7 on 2021/9/2.
//

import Foundation
import UIKit


public typealias TextFieldDelegate = NSObject & UITextFieldDelegate

open class CustomTextFieldVaildateProxy: TextFieldDelegate {
    
    public var editChangedSelector: Selector { return #selector(textFieldEditChanged(_:)) }
    
    private let style: MikTextFieldFormatterView.CustomFormatterStyle
    
    required public init(style: MikTextFieldFormatterView.CustomFormatterStyle) {
        self.style = style
        super.init()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 忽略高亮
        if let range = textField.markedTextRange, let _ = textField.position(from: range.start, offset: 0) {
            return true
        }
        
        // 可删除
        if string == "" {
            return true
        }
                        
        return self.style.validateInputable(text: textField.text, string: string) == .ok
    }
    
}

// MARK: - Private objc selectors
@objc extension CustomTextFieldVaildateProxy {
        
    private func textFieldEditChanged(_ textField: UITextField) {
        // 高亮忽略
        if let selectedRange = textField.markedTextRange, let _ = textField.position(from: selectedRange.start, offset: 0) {
            return
        }
                
        let finalText: String? = {
            if let formatteTuple = self.style.formatteTuple {
                return textField.text?.mik.formatter(splitLenths: formatteTuple.splitLenths, separator: formatteTuple.separator)
            }
            return textField.text
        }()
        
        guard let utf16text = finalText?.utf16, utf16text.count > self.style.inputMaxCount else {
            // 正常输入范围
            return
        }
                
        var subText: String?
        var indexCount = self.style.inputMaxCount
        repeat {
            // 解决'emoji'等长度大1的字符导致截取字符串为nil的问题
            let index = utf16text.index(utf16text.startIndex, offsetBy: indexCount)
            subText = String(utf16text[..<index])
            indexCount -= 1
        }while ( subText == nil && indexCount > 0 )
        
        textField.text = subText
    }
    
}

// MARK: - MikTextFieldFormatterView.CustomFormatterStyle
fileprivate extension MikTextFieldFormatterView.CustomFormatterStyle {
    
    /// 允许输入的最大长度
    var inputMaxCount: Int {
        switch self {
        case .phone(let len): return len + (self.formatteTuple?.separator.utf16.count ?? 0) * 2
        case .digits(let maxLenth, let splitLenths, let separator):
            if let maxLenth = maxLenth {
                return maxLenth + max(0, (splitLenths?.count ?? 0) - 1) * (separator?.utf16.count ?? 0)
            }
            return Int.max
        }
    }
    
    /// 校验结果
    enum ValidateResult: Error {
        case ok, outOfbounds, whitespaces, undigits
    }
    
    
    /// 校验是否允许输入
    /// - Parameters:
    ///   - text: 当前已输入字符
    ///   - string: 将要输入字符
    /// - Returns: 校验结果
    func validateInputable(text: String?, string: String) -> ValidateResult {
        guard (text?.utf16.count ?? 0) < self.inputMaxCount else {
            // 超过允许输入的最大长度
            return .outOfbounds
        }
        
        let validateCharactersRs: ValidateResult = {
            switch self {
            case .phone(_), .digits(_, _, _): return self.validateDigitsInputable(string)
            }
        }()
        
        return validateCharactersRs
    }
    
    /// 校验输入是否是数字
    /// - Parameter string: 输入字符
    /// - Returns: 校验结果
    private func validateDigitsInputable(_ string: String) -> ValidateResult {
        // 校验空格
        if string.trimmingCharacters(in: .whitespaces).isEmpty {
            return .whitespaces
        }
        
        // 校验数字以外的字符
        if string.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil {
            return .undigits
        }
        
        return .ok
    }
    
}

