//
//  MikStarsView.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

public extension Reactive where Base: MikStarsView {
    
    var star: ControlProperty<Float> {
        return controlProperty(editingEvents: [.valueChanged], getter: { starsView in
            starsView.star
        }, setter: { (starsView, star) in
            if starsView.star != star {
                starsView.star = star
            }
        })
    }
    
}

public class MikStarsView: UIControl {
        
    public struct Config {
        public var maximumImage: UIImage? = UIImage.image("mik_scorestar")
        public var minimumImage: UIImage? = UIImage.image("mik_scorestarfill")
        public var maximumTincolor: UIColor = UIColor.mik.general(.hex1B1B1B)
        public var minimumTincolor: UIColor = UIColor.mik.general(.hex1B1B1B)
        public var starHeight: CGFloat = 12
        public var space: CGFloat = 4
        public var repeatCount: Int = 5
        public var isEditEnable = false

        public init() {}
    }
    
    public var star: Float {
        get { self.pStar }
        set { self.pStar = newValue.isNaN ? 0 : newValue }
    }
    
    private var pStar: Float = 0 {
        didSet {
            guard pStar != oldValue else { return }
            self.setNeedsDisplay()
        }
    }
    
    private let config: Config
    
    
    private lazy var maximunImgViews: [UIImageView] = (0 ..< config.repeatCount).map({ _ in
        let imgView = MSImageView(image: config.maximumImage?.withRenderingMode(.alwaysTemplate), size: CGSize(width: config.starHeight, height: config.starHeight))
        imgView.tintColor = config.maximumTincolor
        return imgView
    })
    
    private lazy var minimumImgViews: [UIImageView] = (0 ..< config.repeatCount).map({ _ in
        let imgView = MSImageView(image: config.minimumImage?.withRenderingMode(.alwaysTemplate), size: CGSize(width: config.starHeight, height: config.starHeight))
        imgView.tintColor = config.minimumTincolor
        return imgView
    })
    
    private lazy var maximunStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: maximunImgViews)
        aStackView.axis = .horizontal
        aStackView.alignment = .center
        aStackView.spacing = config.space
        aStackView.distribution = .fillEqually
        return aStackView
    }()
    
    private lazy var minimumStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: minimumImgViews)
        aStackView.axis = .horizontal
        aStackView.alignment = .center
        aStackView.spacing = config.space
        aStackView.distribution = .fillEqually
        return aStackView
    }()
    
    private lazy var maskProgressView: UIView = {
        let aView = UIView()
        aView.backgroundColor = .clear
        aView.layer.mask = maskLayer
        return aView
    }()
    
    private lazy var maskLayer: CAShapeLayer = {
        let aLayer = CAShapeLayer()
        aLayer.fillColor = UIColor.white.cgColor
        return aLayer
    }()
    
    public required init(config: Config = Config()) {
        self.config = config
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    public convenience init(starHeight: CGFloat) {
        self.init(config: {
            var config = Config()
            config.starHeight = starHeight
            return config
        }())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        
        guard config.isEditEnable, self.bounds.contains(point) else {
            return view
        }
        
        let itemWidth = config.starHeight + config.space
        let bStar = Float(min(Int((point.x + itemWidth - 1) / itemWidth), config.repeatCount))
        if star != bStar {
            star = bStar
            sendActions(for: .valueChanged)
        }
        
        return view
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        maskLayer.path = {            
            let width = CGFloat(Int(star)) * config.space + CGFloat(star) * config.starHeight
            return UIBezierPath(rect: CGRect(x: 0, y: 0, width: min(width, rect.width), height: rect.height)).cgPath
        }()
    }
    
}

// MARK: - Assistant
extension MikStarsView {
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
    }
    
    private func setupSubviews() {
        maskProgressView.addSubview(minimumStackView)
        
        addSubview(maximunStackView)
        insertSubview(maskProgressView, aboveSubview: maximunStackView)
    }
    
    private func setupSubviewsConstraints() {
        maximunStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        maskProgressView.snp.makeConstraints { make in
            make.size.centerX.centerY.equalTo(maximunStackView)
        }
        
        minimumStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: - MSImageView
fileprivate class MSImageView: UIImageView {
    
    private let contentSize: CGSize
    
    override var intrinsicContentSize: CGSize { contentSize }
    
    required init(image: UIImage?, size: CGSize) {
        self.contentSize = size
        super.init(image: image)
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
