//
//  MikOmitTextView.swift
//  Demo
//
//  Created by gaowei on 2021/11/27.
//

// tips: 一定是设置视图位置后才赋值text
// MikOmitTextView.configure(isOpen: false, text: "the\n\n\n")

import UIKit

fileprivate class LinkTextView: UITextView {
    
    // MARK: - 禁止长按设置
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    // 防止在任何情况下选择蓝色背景
    override var selectedTextRange: UITextRange? {
        get {
            return nil
        }
        set {}
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            // required for compatibility with isScrollEnabled
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        if let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer,
           tapGestureRecognizer.numberOfTapsRequired == 1 {
            // required for compatibility with links
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        // allowing smallDelayRecognizer for links
        // https://stackoverflow.com/questions/46143868/xcode-9-uitextview-links-no-longer-clickable
        if let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer,
           // comparison value is used to distinguish between 0.12 (smallDelayRecognizer) and 0.5 (textSelectionForce and textLoupe)
           longPressGestureRecognizer.minimumPressDuration < 0.325 {
            return super.gestureRecognizerShouldBegin(gestureRecognizer)
        }
        // preventing selection from loupe/magnifier (_UITextSelectionForceGesture), multi tap, tap and a half, etc.
        gestureRecognizer.isEnabled = false

        return false
    }
    
}

public class MikOmitTextView: UIView {
    
    public var takeRefreshOpen: ((Bool) -> ())?
    
    public var font: UIFont = UIFont.systemFont(ofSize: 14.0) // 字体
    public var textColor: UIColor = UIColor.init(_colorLiteralRed: 27.0/255, green: 27.0/255, blue: 27.0/255, alpha: 1.0) // 颜色
    public var omitColor: UIColor = UIColor.init(_colorLiteralRed: 4.0/255, green: 117.0/255, blue: 188.0/255, alpha: 1.0) // 省略颜色
    public var omitCount: Double = 3 // 缩略3行
    
    private var textString: String? {
        didSet {
            omitString = nil
            if self.bounds.width <= 0 {
                self.layoutIfNeeded()
            }
            self.showTestText()
        }
    }
    
    private var isOpen = false // 内容是否展开（默认收起状态）
    private var topicString: String {
        get {
            return isOpen ? "Show Less" : "Read More"
        }
    }
    
    private var omitString: String? // 缩放后的字符
    
    private lazy var textView: LinkTextView = {
        let item = LinkTextView()
        item.delegate = self
        item.isEditable = false
        item.isSelectable = true // 允许点击事件
        item.scrollsToTop = false
        item.isScrollEnabled = false
        item.bounces = false
        item.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        item.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        item.textContainer.lineFragmentPadding = 0 // 此行是关键
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MikOmitTextView {
    
    private func showTestText() {
        
        var contentStr: String = textString ?? ""
        if isOpen {
            contentStr = self.stringByTruncatingString(isOpen: isOpen, str: (textString ?? ""), suffixStr: " \(topicString)")
        } else {
            contentStr = self.stringByTruncatingString(isOpen: isOpen, str: (textString ?? ""), suffixStr: "... \(topicString)")
        }
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let attStr = NSMutableAttributedString.init(string: contentStr, attributes: [
            NSAttributedString.Key.foregroundColor: textColor,
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.paragraphStyle: style] )
        if !(contentStr.range(of: topicString)?.isEmpty ?? true) { //给富文本的后缀添加点击事件
            let range = NSRange.init(location: (attStr.length - topicString.count), length: topicString.count)
            self.textView.linkTextAttributes = [NSAttributedString.Key.foregroundColor : omitColor]
            
            let valueStr = "didAction://\(topicString)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
            attStr.addAttribute(.link, value: (valueStr ?? ""), range: range)
        }
        self.textView.attributedText = attStr
    }
    
    /// 截取文本
    private func stringByTruncatingString(isOpen: Bool, str: String, suffixStr: String) -> String {
        
        if str.isEmpty {
            return str
        }
        
        if isOpen {
            return str + suffixStr
        } else {
            if !(omitString?.isEmpty ?? true) {
                return omitString ?? ""
            }
        }
        
        var showWidth = self.frame.size.width // 文本显示宽度
        if showWidth == 0 {
            showWidth = UIScreen.main.bounds.size.width
        }
        let actualHeight: CGFloat = self.boundingRect(text: str, font: self.font, limitSize: CGSize.init(width: showWidth, height: CGFloat(MAXFLOAT))).height
        if actualHeight <= (self.font.lineHeight * CGFloat(omitCount)) {
            return str
        }
        
        let rate = Double(self.bounds.width) / 327
        let index = Int(ceil(40 * rate) * omitCount)
        omitString = self.prefixString(showWidth: showWidth, str: str, suffixStr: suffixStr, index: index, isUp: false)
        
        return omitString ?? ""
    }
    
    private func prefixString(showWidth: CGFloat, str: String, suffixStr: String, index: Int, isUp: Bool) -> String {
        if str.count < index {
            // 为什么用2，防止死循环，例：the\n\n\n
            let i = (str.count - 2) > 0 ? (str.count - 2) : 0
            return self.prefixString(showWidth: showWidth, str: str, suffixStr: suffixStr, index: i, isUp: false)
        }
        
        let result = String(str.prefix(index)) + suffixStr
        let height = self.boundingRect(text: result, font: self.font, limitSize: CGSize.init(width: showWidth, height: CGFloat(MAXFLOAT))).height
        if height > self.font.lineHeight * CGFloat(omitCount) {
            if isUp {
                return String(str.prefix(index - 1)) + suffixStr
            } else {
                return self.prefixString(showWidth: showWidth, str: str, suffixStr: suffixStr, index: (index - 1), isUp: false)
            }
        } else {
            return self.prefixString(showWidth: showWidth, str: str, suffixStr: suffixStr, index: (index + 1), isUp: true)
        }
    }
    
    /// 计算文本尺寸
    private func boundingRect(text: String, font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        let attContent = NSMutableAttributedString(string: text, attributes: att)
        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin], context: nil).size
        return CGSize(width: size.width, height: size.height)
    }
    
}

extension MikOmitTextView: UITextViewDelegate {
    
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "didAction" {
            
            isOpen = !isOpen
            self.showTestText()
            self.takeRefreshOpen?(isOpen)
            
            return false
        }
        
        return false
    }
    
}

extension MikOmitTextView {
    
    public func configure(isOpen: Bool, text: String?) {
        self.isOpen = isOpen
        self.textString = text
    }
    
}
