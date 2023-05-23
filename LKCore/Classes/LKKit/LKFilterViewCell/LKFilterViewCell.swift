//
//  LKFilterViewCell.swift
//  LKCore
//
//  Created by gaowei on 2021/4/21.
//

import UIKit
import SnapKit

public class LKFilterViewCell: UIView {

    var takeClickBlock: ((_ tag: Int) -> ())?
    
    
    public var isHiddenImage: Bool = false {
        didSet {
            self.imageView.isHidden = self.isHiddenImage
        }
    }
    public var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    public var title: String? {
        get {
            return self.titleLabel.text
        }
        set(newValue) {
            self.titleLabel.text = newValue
        }
    }
    public var titleFont: UIFont? {
        didSet {
            self.titleLabel.font = self.titleFont
        }
    }
    
    public var isShowLayerLine = false {
        didSet {
            if isShowLayerLine {
                self.bgButton.layer.cornerRadius = 4.rate
                self.bgButton.layer.borderWidth = 1.0
                self.bgButton.layer.borderColor = UIColor.lk.color(.hexAEAEAE).cgColor
                self.bgButton.layer.rasterizationScale = layer.contentsScale // 避免离屏渲染，使用光栅化技术将圆角缓存
            }
        }
    }
    
    public lazy var bgButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.isUserInteractionEnabled = false
        button.setImage(UIImage.lk.image(.white), for: .normal)
        button.setImage(UIImage.lk.image(UIColor.lk.color(.hexF6F6F6)), for: .selected)
        return button
    }()
    
    public lazy var selectButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.setImage(UIImage.image("lk_number_plus"), for: .normal)
        button.setImage(UIImage.image("lk_x"), for: .selected)
        button.contentHorizontalAlignment = .right
        button.addTarget(self, action: #selector(selectButtonAction), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var imageView: UIImageView = {
        let item = UIImageView()
        return item
    }()
    
    private lazy var titleLabel: UILabel = {
        let item = UILabel()
        item.font = UIFont.lk.font(size: 14.rate)
        item.textColor = UIColor.lk.text(.hex1B1B1B)
        return item
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.bgButton)
        self.bgButton.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(60.rate)
        }
        
        let stackView = UIStackView.init(arrangedSubviews: [self.imageView, self.titleLabel])
        stackView.axis = .horizontal
        stackView.spacing = 16.rate
        stackView.alignment = .fill
        stackView.distribution = .fill
        self.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16.rate)
        }
        
        self.addSubview(self.selectButton)
        self.selectButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16.rate)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(80.rate)
            make.height.equalTo(60.rate)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func selectButtonAction() {
        self.takeClickBlock?(self.tag)
    }
}

extension LKFilterViewCell {
    
    public func setTitle(_ title: String, number: Int) {
        let attr = NSMutableAttributedString(string: title, attributes: [NSAttributedString.Key.font : UIFont.lk.font(size: 16.rate), NSAttributedString.Key.foregroundColor : UIColor.lk.color(.hex1B1B1B)])
        if number > 0 {
            let countAttr = NSAttributedString(string: "（\(number)）", attributes: [NSAttributedString.Key.font : UIFont.lk.font(.nunitoSans, size: 16.rate), NSAttributedString.Key.foregroundColor : UIColor.red])
            attr.append(countAttr)
        }
        self.titleLabel.attributedText = attr
    }
}
