//
//  GuideContentView.swift
//  LKMobile
//
//  Created by gaowei on 2021/3/25.
//

import UIKit

enum GuideArrowDirection {
    case up
    case down
}

class GuideContentView: UIView {
    
    var arrowDirection = GuideArrowDirection.up
    
    /// 箭头边距
    private var arrowMargin: CGFloat = 12.rate
    /// 箭头高度
    private var arrowHeight: CGFloat = 23.rate
    private var arrowWidth: CGFloat = 39.rate
    /// 视图圆角
    private var cornerRadius: CGFloat = 20.rate
    
    /// 视图约束边距
    private var snpMargin: CGFloat = 24.rate
    private var snpSuperMargin: CGFloat = 28.rate
    private var contentMargin: CGFloat = 8.rate
    
    
    
    private var titleHeight: CGFloat = 0.0
    private var contentHeight: CGFloat = 0.0
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    required init(_ alphaRect: CGRect, _ title: NSAttributedString?, _ content: NSAttributedString?) {
        super.init(frame: .zero)
        
        /// 确定内容高度
        var height: CGFloat = 24.rate
        if title != nil {
            let rect = self.getStringRect(text: title!)
            height += rect.size.height
            height += contentMargin
            
            titleHeight = rect.height
        }
        if content != nil {
            let rect = self.getStringRect(text: content!)
            height += rect.size.height
            
            contentHeight = rect.height
        }
        height += 24.rate
        height += arrowHeight
        
        /// 确定箭头方向
        let topMargin = alphaRect.minY
        let downMargin = alphaRect.maxY
        if topMargin > (height + arrowMargin) && downMargin > (UIScreen.lk.height - height - arrowMargin) {
            self.arrowDirection = .up
            
            /// 设置视图
            self.frame = CGRect.init(x: snpSuperMargin, y: topMargin - height - arrowMargin, width: UIScreen.main.bounds.width - snpSuperMargin * 2, height: height)
            
        } else {
            self.arrowDirection = .down
            
            /// 设置视图
            self.frame = CGRect.init(x: snpSuperMargin, y: downMargin, width: UIScreen.main.bounds.width - snpSuperMargin * 2, height: height)
        }
        
        /// 添加视图
        if title != nil {
            self.titleLabel.attributedText = title
            self.addSubview(self.titleLabel)
            
            if self.arrowDirection == .up {
                self.titleLabel.frame = CGRect.init(x: snpMargin, y: snpMargin, width: UIScreen.lk.width - snpSuperMargin * 2 - snpMargin * 2, height: titleHeight)
            } else {
                self.titleLabel.frame = CGRect.init(x: snpMargin, y: arrowMargin + snpMargin, width: UIScreen.lk.width - snpSuperMargin * 2 - snpMargin * 2, height: titleHeight)
            }
        }
        if content != nil {
            self.contentLabel.attributedText = content
            self.addSubview(self.contentLabel)
            self.contentLabel.frame = CGRect.init(x: snpMargin, y: self.titleLabel.frame.maxY + contentMargin, width: UIScreen.lk.width - snpSuperMargin * 2 - snpMargin * 2, height: contentHeight)
        }
        
        /// 添加箭头背景
        self.addShapeLayer(alphaRect)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GuideContentView {
    /// 计算内容高度
    func getStringRect(text: NSAttributedString) -> CGRect {
        let size: CGSize = CGSize(width: UIScreen.main.bounds.width - snpSuperMargin * 2 - snpMargin * 2, height: 1000)
        let options: NSStringDrawingOptions =  [ NSStringDrawingOptions.usesFontLeading,  NSStringDrawingOptions.usesLineFragmentOrigin ]
        return text.boundingRect(with: size, options: options, context: nil)
    }

    private func addShapeLayer(_ alphaRect: CGRect) {
        
        let bubblePath = CGMutablePath()
        if arrowDirection == .up {
            let targetPoint = CGPoint(x: alphaRect.midX - self.frame.minX, y: self.bounds.height)
            
            bubblePath.move(to: targetPoint)
            bubblePath.addLine(to: CGPoint(x: targetPoint.x + arrowWidth / 2, y: self.bounds.height - arrowHeight))
            bubblePath.addArc(tangent1End: CGPoint(x: self.bounds.width, y: self.bounds.height - arrowHeight), tangent2End: CGPoint(x: self.bounds.width, y: 0), radius: cornerRadius)
            bubblePath.addArc(tangent1End: CGPoint(x: self.bounds.width, y: 0), tangent2End: CGPoint(x: 0, y: 0), radius: cornerRadius)
            bubblePath.addArc(tangent1End: CGPoint(x: 0, y: 0), tangent2End: CGPoint(x: 0, y: self.bounds.height - arrowHeight), radius: cornerRadius)
            bubblePath.addArc(tangent1End: CGPoint(x: 0, y: self.bounds.height - arrowHeight), tangent2End: CGPoint(x: targetPoint.x - arrowWidth / 2, y: self.bounds.height - arrowHeight), radius: cornerRadius)
            bubblePath.addLine(to: CGPoint(x: targetPoint.x - arrowWidth / 2, y: self.bounds.height - arrowHeight))
            
        } else {
            let targetPoint = CGPoint(x: alphaRect.midX - self.frame.minX, y: 0)
            
            bubblePath.move(to: targetPoint)
            bubblePath.addLine(to: CGPoint(x: targetPoint.x + arrowWidth / 2, y: arrowHeight))
            bubblePath.addArc(tangent1End: CGPoint(x: self.bounds.width, y: arrowHeight), tangent2End: CGPoint(x: self.bounds.width, y: self.bounds.height), radius: cornerRadius)
            bubblePath.addArc(tangent1End: CGPoint(x: self.bounds.width, y: self.bounds.height), tangent2End: CGPoint(x: 0, y: self.bounds.height), radius: cornerRadius)
            bubblePath.addArc(tangent1End: CGPoint(x: 0, y: self.bounds.height), tangent2End: CGPoint(x: 0, y: arrowHeight), radius: cornerRadius)
            bubblePath.addArc(tangent1End: CGPoint(x: 0, y: arrowHeight), tangent2End: CGPoint(x: targetPoint.x - arrowWidth / 2, y: arrowHeight), radius: cornerRadius)
            bubblePath.addLine(to: CGPoint(x: targetPoint.x - arrowWidth / 2, y: arrowHeight))
        }
        
        bubblePath.closeSubpath()
        
        let shapeLayer = CAShapeLayer()

//        shapeLayer.lineWidth = 1.0
//        shapeLayer.strokeColor = UIColor.LDColor(rgbValue: 0xCDCDCD).cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        
        shapeLayer.path = bubblePath
        self.layer.insertSublayer(shapeLayer, at: 0)
        
        // 设置阴影
//        self.layer.shadowColor = UIColor.black.cgColor;
//        self.layer.shadowRadius = cornerRadius
//        self.layer.shadowOffset = CGSize.init(width: 0, height: 0);
//        self.layer.shadowOpacity = 0.2;
    }
}
