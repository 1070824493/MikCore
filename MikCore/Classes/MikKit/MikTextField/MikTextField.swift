//
//  MikTextField.swift
//  MikCore
//
//  Created by m7 on 2021/9/2.
//
//  支持输入格式化的 UI 组件
//  注：取值用‘self.text_’, 'text_' 简单的去除了格式化字符
//     ‘self.rx.text_’ 替代了 'self.rx.text'

import UIKit
import RxSwift
import RxCocoa

public extension Reactive where Base: MikTextField {

    // 替代’rx.text‘
    var text_: ControlProperty<String?> {
        return controlProperty(editingEvents: [.allEditingEvents, .valueChanged], getter: { textField in
            textField.text_
        }, setter: { (textField, value) in
            if textField.text != value {
                textField.text = value
            }
        })
    }
    
}

open class MikTextField: UITextField {
    
    public typealias FormatterTuple = (splitLenths: [Int], separator: Character)
    
    /// 用户输入的值
    public var text_: String? {
        if let formatteTuple = self.formatteTuple,
           !formatteTuple.splitLenths.isEmpty,
           !String(formatteTuple.separator).isEmpty {
            return self.text?.split(separator: formatteTuple.separator).joined()
        }
        return self.text
    }
    
    open override var text: String? {
        didSet {
            guard self.isFormatter, let formatteTuple = self.formatteTuple else { return }
            super.text = text?.mik.formatter(splitLenths: formatteTuple.splitLenths, separator: formatteTuple.separator)
        }
    }

    private var formatteTuple: FormatterTuple?
    
    /// 是否格式化
    private var isFormatter: Bool {
        guard let formatteTuple = self.formatteTuple,
              !formatteTuple.splitLenths.isEmpty,
              !String(formatteTuple.separator).isEmpty else {
                  return false
              }
        return true
    }
    
    open override var intrinsicContentSize: CGSize { CGSize(width: UIScreen.main.bounds.width - 48, height: 48) }
    
    convenience public init(frame: CGRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width - 48, height: 48),
                         formatteTuple: FormatterTuple?) {
        self.init(frame: frame)
        
        self.formatteTuple = formatteTuple
        self.setupNotifications()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
fileprivate extension MikTextField {
    
    private func setupNotifications() {
        guard isFormatter, let formatteTuple = self.formatteTuple else { return }
        
        NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: self, queue: OperationQueue.main) { (noti) in
            guard let textField = noti.object as? UITextField else { return }
            
            // 格式化之前的光标位置
            let oldRange = textField.selectedTextRange
            
            // 光标是否在末尾
            let isAtLast: Bool = {
                if let oldRange = oldRange {
                    let location = textField.offset(from: textField.beginningOfDocument, to: oldRange.start)
                    let lenth = textField.offset(from: oldRange.start, to: oldRange.end)
                    return location + lenth == (textField.text ?? "").count
                }
                return true
            }()

            defer {
                DispatchQueue.main.async {
                    if isAtLast {
                        // 格式化之前光标在末尾, 格式化后也需要指定到末尾
                        let startIndex = textField.position(from: textField.beginningOfDocument, offset: textField.text?.count ?? 0) ?? textField.endOfDocument
                        let endIndex = textField.position(from: startIndex, offset: 0) ?? textField.endOfDocument
                        textField.selectedTextRange = textField.textRange(from: startIndex, to: endIndex)
                    }else {
                        // 格式化之前光标在哪个位置，格式化后也要指定到对应位置
                        textField.selectedTextRange = oldRange
                    }
                }
            }
            
            textField.text = textField.text?.mik.formatter(splitLenths: formatteTuple.splitLenths, separator: formatteTuple.separator)
        }
    }
    
}
