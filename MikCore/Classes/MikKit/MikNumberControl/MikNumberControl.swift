//
//  MikNumberControl.swift
//  MikMobile
//
//  Created by m7 on 2021/3/19.
//

import UIKit
import SnapKit

public class MikNumberControl: UIControl {
    
    /// configure
    public struct Config {
        public init(){ }
        
        /// min value, default 1
        public var minValue: Int = 1
        /// max value, default Int.max
        public var maxValue: Int = Int.max
    }
    
    /// value changed call back
    public var valueChangedHandler: ((Int) -> Void)?
    
    /// current value
    public var value: Int = 0 {
        didSet {
            self.update()
        }
    }
    
    public override var isEnabled: Bool {
        didSet {
            guard isEnabled != oldValue else { return }
            self.update()
        }
    }
    
    private let config: Config

    private lazy var minusBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6)), for: .normal)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6)), for: .disabled)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF3F3F3, alpha: 0.5)), for: .highlighted)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        aBtn.setImage(UIImage.image("mik_number_minus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnMinusButton(_:)), for: .touchUpInside)
        return aBtn
    }()
    
    private lazy var plusBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6)), for: .normal)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6)), for: .disabled)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6, alpha: 0.5)), for: .highlighted)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 14, bottom: 10, right: 14)
        aBtn.setImage(UIImage.image("mik_number_plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        aBtn.addTarget(self, action: #selector(didClickOnPlusButton(_:)), for: .touchUpInside)
        return aBtn
    }()
    
    private lazy var valueBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.isUserInteractionEnabled = false
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6)), for: .normal)
        aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hexF6F6F6)), for: .disabled)
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 16)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        aBtn.setTitleColor(UIColor.mik.text(.hex1B1B1B), for: .normal)
        aBtn.setTitleColor(UIColor.mik.text(.hexCDCDCD), for: .disabled)
        aBtn.setTitle("\(value)", for: .normal)
        return aBtn
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [minusBtn, valueBtn, plusBtn])
        aStackView.axis = .horizontal
        aStackView.alignment = .fill
        aStackView.spacing = 1
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    public required init(config: Config?) {
        self.config = config ?? Config()
        
        super.init(frame: .zero)
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.masksToBounds = true
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension MikNumberControl {
    
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
extension MikNumberControl {
    
    private func update() {
        let isValueEnable = self.isEnabled
        self.valueBtn.isEnabled = isValueEnable
        self.valueBtn.tintColor = isValueEnable ? UIColor.mik.general(.hex1B1B1B) : UIColor.mik.general(.hexCDCDCD)
        self.valueBtn.setTitle("\(value)", for: .normal)
        
        let isMinusEnable = self.isEnabled && self.value > self.config.minValue
        self.minusBtn.isEnabled = isMinusEnable
        self.minusBtn.tintColor = isMinusEnable ? UIColor.mik.general(.hex1B1B1B) : UIColor.mik.general(.hexCDCDCD)
        
        let isPlusEnable = self.isEnabled && self.value < self.config.maxValue
        self.plusBtn.isEnabled = isPlusEnable
        self.plusBtn.tintColor = isPlusEnable ? UIColor.mik.general(.hex1B1B1B) : UIColor.mik.general(.hexCDCDCD)
    }
    
    @objc
    private func didClickOnMinusButton(_ sender: UIButton) {
        guard self.value > self.config.minValue else { return }
        defer { sendActions(for: .valueChanged) }
        self.value -= 1
        self.valueChangedHandler?(self.value)
    }
    
    @objc
    private func didClickOnPlusButton(_ sender: UIButton) {
        guard self.value < self.config.maxValue else { return }
        defer { sendActions(for: .valueChanged) }
        self.value += 1
        self.valueChangedHandler?(self.value)
    }
    
}
