//
//  FilterControllerBottomView.swift
//  SellerMobile
//
//  Created by gaowei on 2021/3/27.
//

import UIKit
import SnapKit

public class MikBottomButtonView: UIView {
    
    public var takeBottomButtonBlock: ((_ title: String, _ index: Int) -> ())?
    
    lazy private var buttons = [UIButton]()
    
    public init(title: String, titleColor: UIColor = UIColor.mik.text(.hexFFFFFF), bgColor: UIColor = UIColor.mik.general(.hexCF1F2E)) {
        super.init(frame: .zero)
        
        let button = UIButton.init(type: .custom)
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14.rate)
        button.setTitle(title.mik.capitalized(), for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.setTitleColor(titleColor, for: .highlighted)
        if !self.isEqualToColor(colorA: titleColor, colorB: UIColor.white) {
            button.setTitleColor(UIColor.mik.general(.hexCDCDCD), for: .disabled)
        }
        button.setBackgroundImage(UIImage.mik.image(bgColor), for: .normal)
        button.setBackgroundImage(UIImage.mik.image(bgColor), for: .highlighted)
        if !self.isEqualToColor(colorA: bgColor, colorB: UIColor.white) {
            button.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexCDCDCD)), for: .disabled)
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
    
    public init(titles: [String], titleColors: [UIColor] = [UIColor.mik.text(.hexCF1F2E), UIColor.mik.text(.hexFFFFFF)], bgColors: [UIColor] = [UIColor.mik.general(.hexFFFFFF), UIColor.mik.general(.hexCF1F2E)]) {
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
            button.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14.rate)
            button.setTitle(item.mik.capitalized(), for: .normal)
            button.setTitleColor(titleColors[index], for: .normal)
            button.setTitleColor(titleColors[index], for: .highlighted)
            if !self.isEqualToColor(colorA: titleColors[index], colorB: UIColor.white) {
                button.setTitleColor(UIColor.mik.general(.hexCDCDCD), for: .disabled)
            }
            button.setBackgroundImage(UIImage.mik.image(bgColors[index]), for: .normal)
            button.setBackgroundImage(UIImage.mik.image(bgColors[index]), for: .highlighted)
            if !self.isEqualToColor(colorA: bgColors[index], colorB: UIColor.white) {
                button.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexCDCDCD)), for: .disabled)
            }
            button.layer.borderWidth = index == 0 ? 2 : 0
            button.layer.borderColor = UIColor.mik.text(.hexCF1F2E).cgColor
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

extension MikBottomButtonView {
    
    private func isEqualToColor(colorA: UIColor, colorB: UIColor) -> Bool {
        var redA: CGFloat = 0, greenA: CGFloat = 0, blueA: CGFloat = 0, alphaA: CGFloat = 0
        colorA.getRed(&redA, green: &greenA, blue: &blueA, alpha: &alphaA)
        
        var redB: CGFloat = 0, greenB: CGFloat = 0, blueB: CGFloat = 0, alphaB: CGFloat = 0
        colorB.getRed(&redB, green: &greenB, blue: &blueB, alpha: &alphaB)
        
        return redA == redB && greenA == greenB && blueA == blueB && alphaA == alphaB
    }
    
}

// MARK: - 开放方法
public extension MikBottomButtonView {
    
    func setButtonTitle(_ title: String, index: Int) {
        if index < self.buttons.count {
            let button = self.buttons[index]
            button.setTitle(title.mik.capitalized(), for: .normal)
        }
    }
    
    func setButton(isEnabled: Bool, index: Int) {
        if index < self.buttons.count {
            let button = self.buttons[index]
            button.isEnabled = isEnabled
            
            if isEnabled {
                button.layer.borderColor = UIColor.mik.general(.hexCF1F2E).cgColor
            } else {
                button.layer.borderColor = UIColor.mik.general(.hexCDCDCD).cgColor
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
