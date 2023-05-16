//
//  MikLockSlider.swift
//  MikLockSlider
//
//  Created by ayong on 2021/7/19.
//

import UIKit

//MARK: - Class defines
public class MikLockSlider: UIControl {
    
    public var titleConf = TitleConfigure.default
    public var thumbConf = ThumbImageViewConfigure.default
        
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = titleConf.title
        label.textColor = titleConf.color
        label.textAlignment = .center
        label.font = titleConf.font
        return label
    }()
    
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.image("mik_component_lock_slider_thumb"))
        imageView.backgroundColor = thumbConf.backgroundColor
        imageView.contentMode = .center
        imageView.clipsToBounds = true
        return imageView
    }()
    
    public init(title: String = "Slide to unlock") {
        super.init(frame: .zero)
        self.titleConf.title = title
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        addSubview(thumbImageView)
        setBaseStyle(cornerRadius: 25, borderWidth: 2, borderColor: titleConf.color)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        let minX = layer.borderWidth+thumbConf.insets.left
        if thumbImageView.frame.origin.x < minX {
            thumbImageView.frame = newThumbImageViewOriginalFrame
        }else{
            var newFrame = newThumbImageViewOriginalFrame
            newFrame.origin.x = thumbImageView.frame.origin.x
            thumbImageView.frame = newFrame
        }
        if thumbImageView.layer.cornerRadius != thumbImageView.bounds.height/2 {
            thumbImageView.layer.cornerRadius = thumbImageView.bounds.height/2
        }
    }
    
    private var newThumbImageViewOriginalFrame: CGRect {
        CGRect(x: layer.borderWidth+thumbConf.insets.left,
               y: layer.borderWidth+thumbConf.insets.top,
               width: thumbConf.width,
               height: bounds.height-2*layer.borderWidth-thumbConf.insets.top-thumbConf.insets.bottom)
    }
    
}

//MARK: - Public functions
public extension MikLockSlider {
    
    func setBaseStyle(cornerRadius: CGFloat,
                             borderWidth: CGFloat = 2,
                             borderColor: UIColor? = UIColor(red: 207/255.0, green: 31/255.0, blue: 46/255.0, alpha: 1),
                             titleConf: TitleConfigure = .default,
                             thumbConf: ThumbImageViewConfigure = .default) {
        layer.cornerRadius = cornerRadius
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor?.cgColor
        
        thumbImageView.frame = newThumbImageViewOriginalFrame
    }
    
    func setLockStyle() {
        UIView.animate(withDuration: 0.35) {
            self.thumbImageView.transform = .identity
            self.titleLabel.alpha = 1
        }
        self.isUserInteractionEnabled = true
    }
    
    func setUnlockStyle() {
        let maxX = bounds.width-thumbImageView.frame.width-thumbConf.insets.right-layer.borderWidth
        UIView.animate(withDuration: 0.35) {
            self.thumbImageView.transform = self.thumbImageView.transform.translatedBy(x: maxX-self.thumbImageView.frame.origin.x, y: 0)
            self.titleLabel.alpha = 0
        } completion: { (finished) in
            self.sendActions(for: .valueChanged)
        }
        self.isUserInteractionEnabled = false
    }
    
}

//MARK: - Touch Events
extension MikLockSlider {
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let currentPoint = touch.location(in: self)
        let previousPoint = touches.first?.precisePreviousLocation(in: self) ?? .zero
        
        let minX = layer.borderWidth+thumbConf.insets.left
        let maxX = bounds.width-thumbImageView.frame.width-thumbConf.insets.right-layer.borderWidth
        var tx = currentPoint.x-previousPoint.x
        if tx+thumbImageView.frame.origin.x > maxX {
            tx = maxX-thumbImageView.frame.origin.x
        }
        if tx+thumbImageView.frame.origin.x < minX {
            tx = minX-thumbImageView.frame.origin.x
        }
        
        thumbImageView.transform = thumbImageView.transform.translatedBy(x: tx, y: 0)
        titleLabel.alpha = (1-thumbImageView.frame.origin.x/maxX)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouch(touches)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        endTouch(touches)
    }
    
    private func endTouch(_ touches: Set<UITouch>) {
        let maxX = bounds.width-thumbImageView.frame.width-thumbConf.insets.right-layer.borderWidth
        switch self.thumbImageView.frame.origin.x {
        case maxX*0.85...maxX:
            self.setUnlockStyle()
        default:
            self.setLockStyle()
        }
    }
    
}

//MARK: - UI Configure
extension MikLockSlider {
    
    public struct TitleConfigure {
        public var title: String?
        public var color: UIColor?
        public var font: UIFont?
        
        public init(title: String?, color: UIColor?, font: UIFont?) {
            self.title = title
            self.color = color
            self.font = font
        }
        
        public static let `default` = TitleConfigure(title: "Slide to unlock",
                                                     color: UIColor(red: 207/255.0, green: 31/255.0, blue: 46/255.0, alpha: 1),
                                                     font: UIFont.boldSystemFont(ofSize: 14))
    }
    
    public struct ThumbImageViewConfigure {
        public var backgroundColor: UIColor?
        public var image: UIImage?
        public var insets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        /// -1: height/2
        public var cornerRadius: CGFloat = -1
        public var width: CGFloat = 72
        
        public init(backgroundColor: UIColor? = UIColor(red: 207/255.0, green: 31/255.0, blue: 46/255.0, alpha: 1),
                    image: UIImage? = UIImage.image("mik_component_lock_slider_thumb"),
                    insets: UIEdgeInsets = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1),
                    cornerRadius: CGFloat = -1,
                    width: CGFloat = 72) {
            self.backgroundColor = backgroundColor
            self.image = image
            self.insets = insets
            self.cornerRadius = cornerRadius
            self.width = width
        }
        
        public static let `default` = ThumbImageViewConfigure(backgroundColor: UIColor(red: 207/255.0, green: 31/255.0, blue: 46/255.0, alpha: 1),
                                                              image: UIImage.image("mik_component_lock_slider_thumb"),
                                                              insets: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1),
                                                              cornerRadius: -1,
                                                              width: 72)
    }
    
}
