//
//  LKStarRateView.swift
//  LKCore
//
//  Created by gaowei on 2021/4/21.
//

import UIKit
import SnapKit

public class LKStarRateView: UIView {
    
    public var currentStarCount: Int = 0 {
        didSet {
            for (index, button) in self.starViews.enumerated() {
                if index < self.currentStarCount {
                    button.isSelected = true
                } else {
                    button.isSelected = false
                }
            }
        }
    }
    
    public var title: String? {
        get {
            return self.titleLabel.text
        }
        set {
            self.titleLabel.text = newValue
        }
    }
    
    public var isHiddenTitle = false {
        didSet {
            self.titleLabel.isHidden = self.isHiddenTitle
        }
    }
    
    private lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.font = UIFont.lk.font(size: 14.rate)
        item.textColor = UIColor.lk.text(.hex1B1B1B)
        
        return item
    }()
    
    private var starViews = [UIButton]()
    
    public required init(numberOfStars: Int = 5, currentStarCount: Int = 0, normalStarImageName: String = "lk_littlestar_n", selectedStarImageName: String = "lk_littlestar_s") {
        super.init(frame: .zero)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2.rate
        stackView.alignment = .center
        stackView.distribution = .fill

        for index in 0 ..< numberOfStars {
            let starButton = UIButton.init(type: .custom)
            starButton.setBackgroundImage(UIImage.image(normalStarImageName), for: .normal)
            starButton.setBackgroundImage(UIImage.image(selectedStarImageName), for: .selected)
            starButton.isUserInteractionEnabled = false
            stackView.addArrangedSubview(starButton)
            starButton.snp.makeConstraints { (make) in
                make.width.equalTo(starButton.snp.height)
                make.top.bottom.equalToSuperview().inset(2.rate)
            }
            
            if index < currentStarCount {
                starButton.isSelected = true
            }
            if index == numberOfStars-1 {
                stackView.setCustomSpacing(8.rate, after: starButton)
            }
            
            starViews.append(starButton)
        }
        
        stackView.addArrangedSubview(self.titleLabel)
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
