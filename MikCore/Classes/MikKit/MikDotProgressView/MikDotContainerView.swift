//
//  MikDotContainerView.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

fileprivate let kDotHeight: CGFloat = 12

class MikDotContainerView: UIView {
    
    var step: Int = 0 {
        didSet {
            self.setNeedsDisplay()
            self.dotImgViews.enumerated().forEach({
                $1.isHighlighted = $0 == step
                if $0 <= step {
                    $1.backgroundColor = UIColor.mik.general(.hexCF1F2E)
                }else {
                    $1.backgroundColor = UIColor.mik.general(.hexCDCDCD)
                }
            })
        }
    }

    private let totalStep: Int
    
    private lazy var grayLayer: CAShapeLayer = {
        let aShapeLayer = CAShapeLayer()
        aShapeLayer.strokeColor = UIColor.mik.general(.hexCDCDCD).cgColor
        aShapeLayer.fillColor = UIColor.clear.cgColor
        aShapeLayer.lineWidth = 2
        return aShapeLayer
    }()
    
    private lazy var redLayer: CAShapeLayer = {
        let aShapeLayer = CAShapeLayer()
        aShapeLayer.strokeColor = UIColor.mik.general(.hexCF1F2E).cgColor
        aShapeLayer.fillColor = UIColor.clear.cgColor
        aShapeLayer.lineWidth = 2
        return aShapeLayer
    }()
    
    private lazy var dotImgViews: [UIImageView] = (0 ..< totalStep).map({ _ in MDImageView(frame: .zero) })
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: dotImgViews)
        aStackView.axis = .horizontal
        aStackView.alignment = .center
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    required init(totalStep: Int) {
        self.totalStep = totalStep
        
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
                
        grayLayer.path = {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.lineWidth = 2
            path.lineCapStyle = .round
            return path.cgPath
        }()
        
        redLayer.path = {
            guard step > 0 else { return nil }
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: rect.midY))
            path.addLine(to: CGPoint(x: dotImgViews[step].frame.midX, y: rect.midY))
            path.lineWidth = 2
            path.lineCapStyle = .round
            return path.cgPath
        }()
    }
    
}

// MARK: - Assistant
extension MikDotContainerView {
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
    }
    
    private func setupSubviews() {
        layer.addSublayer(grayLayer)
        layer.addSublayer(redLayer)
        
        addSubview(mStackView)
    }
    
    private func setupSubviewsConstraints() {
        mStackView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: - MDImageView
fileprivate class MDImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize { CGSize(width: kDotHeight, height: kDotHeight) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexCDCDCD)
        highlightedImage = UIImage.image("mik_dot_progress_right")
        contentMode = .center
        layer.cornerRadius = kDotHeight * 0.5
        layer.masksToBounds = true
    }
    
}
