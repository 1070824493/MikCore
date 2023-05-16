//
//  MikStepView.swift
//  MikCore
//
//  Created by gaowei on 2021/4/20.
//

import UIKit
import SnapKit

public class MikStepView: UIView {

    public var takeStepBlock: ((_ title: String, _ tag: Int) -> ())?
    
    private let scrollView: UIScrollView = UIScrollView()
    
    private var buttons = [MikStepButton]()
    
    public required init(titles: [String]) {
        super.init(frame: .zero)
        
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(43.rate)
        }
        
        var leftItem: ConstraintItem = self.snp.left
        for (index, title) in titles.enumerated() {
            let stepButton = self.createButton(title: title)
            stepButton.tag = index
            
            if index == 0 {
                stepButton.isSelected = true
            }
            
            scrollView.addSubview(stepButton)
            self.buttons.append(stepButton)
            
            var width = title.mik.boundingRect(font: stepButton.titleLabel?.font ?? UIFont.mik.font(.nunitoSansBold, size: 14.rate), limitSize: CGSize.init(width: CGFloat(MAXFLOAT), height: 43.rate)).width + 40.rate
            
            if titles.count == 2 {
                width = UIScreen.mik.width / 2.0 - 24.rate
            }
            
            stepButton.snp.makeConstraints { (make) in
                make.top.bottom.equalToSuperview()
                if index == 0 {
                    make.left.equalToSuperview().inset(24.rate)
                } else if index == titles.count - 1 {
                    make.left.equalTo(leftItem).offset(5.rate)
                    make.right.equalToSuperview().inset(24.rate)
                } else {
                    make.left.equalTo(leftItem).offset(5.rate)
                }
                
                make.width.equalTo(width)
                make.height.equalTo(43.rate)
            }
            
            leftItem = stepButton.snp.right
        }
    }
    
    private func createButton(title: String) -> MikStepButton {
        let button = MikStepButton.init(type: .custom)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14.rate)
        button.setTitleColor(UIColor.mik.text(.hexF8D2CB), for: .normal)
        button.setTitleColor(UIColor.mik.text(.hexCF1F2E), for: .selected)
        button.setTitleColor(UIColor.mik.text(.hexCDCDCD), for: .disabled)
        button.setTitle(title, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        
        return button
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MikStepView {
    
    @objc private func buttonAction(btn: MikStepButton) {
        self.takeStepBlock?(btn.currentTitle ?? "", btn.tag)
    }
    
    public func setStepIndex(index: Int, enabledIndex: Int) {
        
        if let currentBtn = self.buttons.mik[safe: index] {
            let minX: CGFloat = 0
            let maxX = self.scrollView.contentSize.width - self.scrollView.frame.width
            let targetX = currentBtn.frame.minX - self.scrollView.frame.width/2 + currentBtn.frame.width/2
            self.scrollView.setContentOffset(CGPoint(x: max(min(maxX, targetX), minX), y: 0), animated: false)
            
            for (i, button) in self.buttons.enumerated() {
                
                button.isSelected = false
                button.isEnabled = false
                
                if i <= enabledIndex {
                    button.isEnabled = true
                }
                if index == i {
                    button.isSelected = true
                }
            }
        }
        
    }
    
    
    public func setStepIndex(index: Int, enabledIndexs: [Int]) {
        
        if  let currentBtn = self.buttons.mik[safe: index] {
            let minX: CGFloat = 0
            let maxX = self.scrollView.contentSize.width - self.scrollView.frame.width
            let targetX = currentBtn.frame.minX - self.scrollView.frame.width/2 + currentBtn.frame.width/2
            self.scrollView.setContentOffset(CGPoint(x: max(min(maxX, targetX), minX), y: 0), animated: false)
            
            self.buttons.forEach { button in
                button.isSelected = false
                button.isEnabled = false
            }
            enabledIndexs.forEach { i in
                if let button = self.buttons.mik[safe: i] {
                    button.isEnabled = true
                }
            }
            currentBtn.isSelected = true
        }
    }
    
}
