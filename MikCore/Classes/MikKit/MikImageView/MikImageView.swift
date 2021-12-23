//
//  MikImageView.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit


fileprivate extension MikImageView.Style {
        
    var config: MikImageView.Config {
        switch self {
        case .buyer:
            return MikImageView.Config(backgroundColor: UIColor.mik.general(.hexF3F3F3), placeholderImage: UIImage.image("mik_placeholder_buyer"))
        case .seller:
            return MikImageView.Config(backgroundColor: UIColor.mik.general(.hexF3F3F3), placeholderImage: UIImage.image("mik_placeholder_seller"))
        }
    }
    
}

open class MikImageView: UIImageView {
    
    public enum Style {
        case buyer, seller
    }
    
    public struct Config {
        public var backgroundColor: UIColor?
        public var placeholderImage: UIImage?
    }
    
    private let config: Config
    
    private lazy var placeholderView: ImagePlaceholderView = ImagePlaceholderView(placeholder: config.placeholderImage)

    open override var image: UIImage? {
        didSet {
            self.backgroundColor = image == nil ? self.config.backgroundColor : .white
            self.placeholderView.isDisplay = image == nil
        }
    }
    
    /// 初始化
    /// - Parameter placeholderImage: 水印图片
    /// - Parameter backgroundColor: 背景颜色
    required public init(config: Config) {
        self.config = config
        
        super.init(frame: .zero)
        configure()
    }
    
    convenience public init(style: Style = .buyer) {
        self.init(config: style.config)
    }
    
    override convenience init(frame: CGRect) {
        fatalError()
    }
    
    required public init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        backgroundColor = config.backgroundColor
        addSubview(placeholderView)
        
        placeholderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.placeholderView.isHighlight = true
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.placeholderView.isHighlight = false
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        self.placeholderView.isHighlight = false
    }
    
}

// MARK: - ImagePlaceholderView
fileprivate class ImagePlaceholderView: UIView {
    
    var isDisplay: Bool = true {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var isHighlight: Bool = false {
        didSet {
            self.backgroundColor = isHighlight ? UIColor.mik.general(.hex000000, alpha: 0.05) : .clear
        }
    }
    
    private let rate: CGFloat = 0.62
    
    private let logoImage: UIImage?
    
    required init(placeholder: UIImage?) {
        self.logoImage = placeholder
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        guard self.isDisplay, let logoImage = self.logoImage else { return }
        
        logoImage.draw(in: self.convertPlaceholdImageSize(fromRect: rect))
    }
    
    private func configure() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }
    
    
    /// 计算水印的位置和大小
    /// - Parameter fromRect: 容器大小
    /// - Returns: 水印的位置和大小
    private func convertPlaceholdImageSize(fromRect: CGRect) -> CGRect {
        guard let logoSize = self.logoImage?.size, fromRect.size.width > 0 else { return .zero }
        
        let logoRate = logoSize.width / logoSize.height
        let fromRate = fromRect.size.width / fromRect.size.height
        
        let bSize: CGSize = {
            if fromRate < logoRate {
                let bWidth = min(fromRect.size.width * rate, logoSize.width)
                return CGSize(width: bWidth, height: bWidth / logoRate)
            }else {
                let bHeight = min(fromRect.size.height * rate, logoSize.height)
                return CGSize(width: bHeight * logoRate, height: bHeight)
            }
        }()
        
        return CGRect(origin: CGPoint(x: (fromRect.size.width - bSize.width) * 0.5, y: (fromRect.size.height - bSize.height) * 0.5), size: bSize)
    }
    
}
