//
//  MikGrowTextView.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit


public class MikGrowTextView: UITextView {
    
    /// TextView content height changed call back
    public var heightChangedBlock: (() -> Void)?
    
    /// Placeholder whith String
    public var placeholder: String? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// Placeholder's color
    public var placeholderColor: UIColor? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// Placeholder whith NSAttributedString
    public var attributePlaceholder: NSAttributedString? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    /// Placeholder's inset
    private var placeHolderInsets: UIEdgeInsets {
        var textInset = textContainerInset
        textInset.left += 3
        return textInset
    }
    
    /// Placeholder's attributes
    private var placeholderTextAttributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = textAlignment
        
        return [.paragraphStyle: paragraphStyle, .font: font ?? UIFont.mik.font(size: 16), .foregroundColor: placeholderColor ?? .lightGray]
    }
    
    override open var text: String! {
        didSet {
            self.setNeedsDisplay()
            self.autoAdjustContentHeight()
        }
    }
    
    override open var attributedText: NSAttributedString! {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override open var font: UIFont? {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override open var textAlignment: NSTextAlignment {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override open var bounces: Bool {
        didSet {
            if contentSize.height <= bounds.size.height + 1 {
                contentOffset = .zero
            }else if !isTracking {
                var offset = contentOffset
                if offset.y > contentSize.height - bounds.size.height {
                    offset.y = contentSize.height - bounds.size.height
                    if !isDecelerating, !isTracking, !isDragging {
                        self.contentOffset = offset
                    }
                }
            }
        }
    }
    
    private var heightConstraint: NSLayoutConstraint?
    private var minHeightConstraint: NSLayoutConstraint?
    private var maxHeightConstraint: NSLayoutConstraint?
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configureTextView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        configureTextView()
    }

    deinit {
        removeTextViewNotificationObservers()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard text.isEmpty else { return }
        
        if let attributePlaceholder = self.attributePlaceholder {
            attributePlaceholder.draw(in: rect.inset(by: placeHolderInsets))
        }else if let placeholder = placeholder  {
            self.placeholderColor?.set()
            (placeholder as NSString).draw(in: rect.inset(by: placeHolderInsets), withAttributes: placeholderTextAttributes)
        }
    }
    
}

// MARK: - Assistant
extension MikGrowTextView {
    
    private func configureTextView() {
        scrollsToTop = false
        isUserInteractionEnabled = true
        contentMode = .redraw
        dataDetectorTypes = UIDataDetectorTypes(rawValue: 0)
        keyboardType = .default
        returnKeyType = .default
        
        addTextViewNotificationObservers()
    }
    
}

// MARK: - Private meds
extension MikGrowTextView {
    
    private func addTextViewNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveTextViewNotification(_:)), name: UITextView.textDidChangeNotification, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveTextViewNotification(_:)), name: UITextView.textDidBeginEditingNotification, object: self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveTextViewNotification(_:)), name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    private func removeTextViewNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
        
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidBeginEditingNotification, object: self)
        
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidEndEditingNotification, object: self)
    }
    
    
    @objc private func didReceiveTextViewNotification(_ notification: Notification) {
        self.setNeedsDisplay()
        self.autoAdjustContentHeight()
    }
    
    private func autoAdjustContentHeight() {
        var newHeight = self.sizeThatFits(self.bounds.size).height
        
        if let maxHeightConstraint = self.maxHeightConstraint {
            newHeight = min(newHeight, maxHeightConstraint.constant)
        }
        
        if let minHeightConstraint = self.minHeightConstraint {
            newHeight = max(newHeight, minHeightConstraint.constant)
        }

        if Decimal(string: "\(self.heightConstraint?.constant ?? 0)") != Decimal(string: "\(newHeight)") {
            self.heightConstraint?.constant = newHeight
            if let heightChangedBlock = self.heightChangedBlock {
                UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveLinear, animations: heightChangedBlock, completion: nil)
            }
        }
    }
    
}

// MARK: - Public meds
public extension MikGrowTextView {
    
    func associateConstraints() {
        for constraint in self.constraints {
            if constraint.firstAttribute == .height {
                if constraint.relation == .equal {
                    self.heightConstraint = constraint
                }else if constraint.relation == .lessThanOrEqual {
                    self.maxHeightConstraint = constraint
                }else if constraint.relation == .greaterThanOrEqual {
                    self.minHeightConstraint = constraint
                }
            }
        }
    }
        
    /// 清空
    func clear() {
        self.text = nil
        self.setNeedsDisplay()
        self.autoAdjustContentHeight()
    }
    
}

extension MikGrowTextView {
    
//    override var canBecomeFirstResponder: Bool {
//        return super.canBecomeFirstResponder
//    }
//    
//    override func becomeFirstResponder() -> Bool {
//        return super.becomeFirstResponder()
//    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        UIMenuController.shared.menuItems = nil
        return super.canPerformAction(action, withSender: sender)
    }
    
}
