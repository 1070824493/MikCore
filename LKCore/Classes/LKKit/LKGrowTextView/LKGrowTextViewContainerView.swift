//
//  LKGrowTextViewContainerView.swift
//  LKCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

public class LKGrowTextViewContainerView: UIView {
    
    public struct Config {
        public var minHeight: CGFloat = 44
        public var maxTextLine: Int = 4
        public init() {}
    }
    
    private let config: Config
    
    private var oneLineHeight: CGFloat { return textView.font?.lineHeight ?? 0 }
    private var minHeight: CGFloat {  CGFloat(max(oneLineHeight, config.minHeight)) }
    private var maxHeight: CGFloat { CGFloat(config.maxTextLine) * oneLineHeight }

    public lazy var textView: LKGrowTextView = {
        let aTextView = LKGrowTextView()
        aTextView.backgroundColor = UIColor.lk.color(.hexFFFFFF)
        aTextView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        aTextView.returnKeyType = .default
        aTextView.textAlignment = .left
        aTextView.font = UIFont.lk.font(.nunitoSans, size: 16)
        aTextView.textColor = UIColor.lk.hex(0x1B1B1B)
        return aTextView
    }()
    
    public required init(config: Config) {
        self.config = config
        
        super.init(frame: .zero)
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension LKGrowTextViewContainerView {
    
    private func setupSubviews() {
        addSubview(textView)
    }
    
    private func setupSubviewsConstraints() {
        defer {
            /// Important...
            textView.associateConstraints()
        }
        
        textView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(minHeight)
            make.height.greaterThanOrEqualTo(minHeight)
            make.height.lessThanOrEqualTo(maxHeight)
        }
    }
    
}
