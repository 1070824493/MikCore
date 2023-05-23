//
//  LKDotProgressView.swift
//  LKCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

open class LKDotProgressView: UIView {

    /// Current step
    public var step: Int = 0 {
        didSet {
            self.dotContainerView.step = min(step, titles.count)
        }
    }
    
    /// Step desc
    public var titles: [String] {
        didSet {
            self.dotDescContainerView.titles = titles
        }
    }
    
    private lazy var dotContainerView: LKDotContainerView = LKDotContainerView(totalStep: titles.count)
    
    private lazy var dotDescContainerView: LKDotDescContainerView = LKDotDescContainerView(titles: titles)
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [dotContainerView, dotDescContainerView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 6
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    convenience init(totalStep: Int) {
        self.init(titles: (0 ..< totalStep).map({ _ in "" }))
    }
    
    required public init(titles: [String]) {
        self.titles = titles
        
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension LKDotProgressView {
    
    private func configure() {
        backgroundColor = UIColor.lk.color(.hexFFFFFF)
    }
    
    private func setupSubviews() {
        addSubview(mStackView)
    }
    
    private func setupSubviewsConstraints() {
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
