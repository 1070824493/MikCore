//
//  LKDotDescContainerView.swift
//  LKCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

class LKDotDescContainerView: UIView {

    var titles: [String] {
        didSet {
            self.labels.enumerated().forEach({
                if titles.indices ~= $0 {
                    $1.text = titles[$0]
                }else {
                    $1.text = nil
                }
            })
        }
    }
    
    private lazy var labels: [UILabel] = (0 ..< titles.count).map({ createLabel(at: $0) })
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: labels)
        aStackView.axis = .horizontal
        aStackView.alignment = .leading
        aStackView.spacing = 4
        aStackView.distribution = .fillEqually
        return aStackView
    }()
    
    required init(titles: [String]) {
        self.titles = titles
        
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension LKDotDescContainerView {
    
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

// MARK: - Private
extension LKDotDescContainerView {
    
    private func createLabel(at index: Int) -> UILabel {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.lk.font(.nunitoSansBold, size: 10)
        label.textColor = UIColor.lk.text(.hex1B1B1B)
        label.textAlignment = {
            if index == 0 { return .left }else if index == titles.count - 1 { return .right }
            return .center
        }()
        label.text = titles[index]
        return label
    }
    
}
