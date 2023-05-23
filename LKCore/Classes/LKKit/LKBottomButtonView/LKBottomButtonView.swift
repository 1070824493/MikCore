//
//  FilterControllerBottomView.swift
//  SellerMobile
//
//  Created by gaowei on 2021/3/27.
//

import UIKit
import SnapKit

public class LKBottomButtonView: UIView {
    
    public var takeBottomButtonBlock: ((_ title: String, _ index: Int) -> ())?
    
    lazy private var buttons = [UIButton]()
    
    public init(title: String, titleColor: UIColor = UIColor.lk.text(.hexFFFFFF), bgColor: UIColor = UIColor.lk.color(.hexCF1F2E)) {
        super.init(frame: .zero)
        
        let button = UIButton.init(type: .custom)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14.rate)
        button.setTitle(title.lk.capitalized(), for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColor, for: .highlighted)
        if !self.isEqualToColor(colorA: titleColor, colorB: UIColor.white) {
            button.setTitleColor(UIColor.lk.color(.hexCDCDCD), for: .disabled)
        }
        button.setBackgroundImage(UIImage.lk.image(bgColor), for: .normal)
        button.setBackgroundImage(UIImage.lk.image(bgColor), for: .highlighted)
        if !self.isEqualToColor(colorA: bgColor, colorB: UIColor.white) {
            button.setBackgroundImage(UIImage.lk.image(UIColor.lk.color(.hexCDCDCD)), for: .disabled)
        }
        button.layer.cornerRadius = 50.rate / 2
        button.tag = 1000
        button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
        self.addSubview(button)
        self.buttons.append(button)
        button.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24.rate)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50.rate)
        }
    }
    
    public init(titles: [String], titleColors: [UIColor] = [UIColor.lk.text(.hexCF1F2E), UIColor.lk.text(.hexFFFFFF)], bgColors: [UIColor] = [UIColor.lk.color(.hexFFFFFF), UIColor.lk.color(.hexCF1F2E)]) {
        super.init(frame: .zero)
        
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 24.rate
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24.rate)
            make.top.bottom.equalToSuperview()
            make.height.equalTo(50.rate)
        }

        for (index, item) in titles.enumerated() {
            let button = UIButton.init(type: .custom)
            button.clipsToBounds = true
            button.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14.rate)
            button.setTitle(item.lk.capitalized(), for: .normal)
            button.setTitleColor(titleColors[index], for: .normal)
            button.setTitleColor(titleColors[index], for: .highlighted)
            if !self.isEqualToColor(colorA: titleColors[index], colorB: UIColor.white) {
                button.setTitleColor(UIColor.lk.color(.hexCDCDCD), for: .disabled)
            }
            button.setBackgroundImage(UIImage.lk.image(bgColors[index]), for: .normal)
            button.setBackgroundImage(UIImage.lk.image(bgColors[index]), for: .highlighted)
            if !self.isEqualToColor(colorA: bgColors[index], colorB: UIColor.white) {
                button.setBackgroundImage(UIImage.lk.image(UIColor.lk.color(.hexCDCDCD)), for: .disabled)
            }
            button.layer.borderWidth = index == 0 ? 2 : 0
            button.layer.borderColor = UIColor.lk.text(.hexCF1F2E).cgColor
            button.layer.cornerRadius = 50.rate / 2
            button.tag = (index + 1000)
            button.addTarget(self, action: #selector(buttonAction(btn:)), for: .touchUpInside)
            stackView.addArrangedSubview(button)
            
            self.buttons.append(button)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: ---- Actions ----
    @objc func buttonAction(btn: UIButton) {
        self.takeBottomButtonBlock?(btn.currentTitle ?? "", (btn.tag - 1000))
    }
    
}

extension LKBottomButtonView {
    
    private func isEqualToColor(colorA: UIColor, colorB: UIColor) -> Bool {
        var redA: CGFloat = 0, greenA: CGFloat = 0, blueA: CGFloat = 0, alphaA: CGFloat = 0
        colorA.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA)
        
        var redB: CGFloat = 0, greenB: CGFloat = 0, blueB: CGFloat = 0, alphaB: CGFloat = 0
        colorB.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB)
        
        return redA == redB && greenA == greenB && blueA == blueB && alphaA == alphaB
    }
    
}

// MARK: - 开放方法
public extension LKBottomButtonView {
    
    func setButtonTitle(_ title: String, index: Int) {
        if index < self.buttons.count {
            let button = self.buttons[index]
            button.setTitle(title.lk.capitalized(), for: .normal)
        }
    }
    
    func setButton(isEnabled: Bool, index: Int) {
        if index < self.buttons.count {
            let button = self.buttons[index]
            button.isEnabled = isEnabled
            
            if isEnabled {
                button.layer.borderColor = UIColor.lk.color(.hexCF1F2E).cgColor
            } else {
                button.layer.borderColor = UIColor.lk.color(.hexCDCDCD).cgColor
            }
        }
    }
    
    func getButton(index: Int) -> UIButton {
        if index < self.buttons.count {
            return self.buttons[index]
        }
        return UIButton()
    }
    
}
