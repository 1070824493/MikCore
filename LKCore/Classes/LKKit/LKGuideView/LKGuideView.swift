//
//  LKGuideView.swift
//  LKCore
//
//  Created by gaowei on 2021/4/23.
//

import UIKit


public enum GuideCornerType {
    case top
    case topLeft
    case topRight
    case bottom
    case bottomLeft
    case bottomRight
    case allCorners
}

public class LKGuideView: UIView {
    
    var guideViewNextBlock: (() -> Void)?
    private var contentView: GuideContentView!
    
    required init(_ fromView: UIView, _ cornerType: GuideCornerType, _ cornerRadius: CGFloat, _ title: NSAttributedString?, _ content: NSAttributedString?) {
        super.init(frame: .zero)
        self.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        let rect = self.convert(fromView.frame, from: fromView.superview)
        self.drawBorderMaskLayer(rect, cornerType, cornerRadius)
        
        contentView = GuideContentView.init(rect, title, content)
        self.addSubview(contentView)
        self.showAnimation()
        
        /// 添加点击隐藏
        let tapSingle = UITapGestureRecognizer(target: self, action: #selector(hiddenAnimation))
        tapSingle.numberOfTapsRequired = 1
        tapSingle.numberOfTouchesRequired = 1
        self.addGestureRecognizer(tapSingle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func drawBorderMaskLayer(_ alphaRect: CGRect, _ cornerType: GuideCornerType, _ cornerRadius: CGFloat) {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.init(red: 27.0/255, green: 27.0/255, blue: 27.0/255, alpha: 0.75).cgColor
        
        let bezierPath = UIBezierPath.init(rect: self.bounds)
        let maskPath = UIBezierPath.init(roundedRect: alphaRect, byRoundingCorners: self.getRectCorner(cornerType), cornerRadii: CGSize.init(width: cornerRadius, height: cornerRadius))
        bezierPath.append(maskPath)
        bezierPath.usesEvenOddFillRule = true
        maskLayer.path = bezierPath.cgPath
        self.layer.insertSublayer(maskLayer, at: 0)
    }
    
    private func getRectCorner(_ cornerType: GuideCornerType) -> UIRectCorner {
        switch cornerType {
        case .top:
            return [UIRectCorner.topLeft, UIRectCorner.topRight]
        case .topLeft:
            return UIRectCorner.topLeft
        case .topRight:
            return UIRectCorner.topRight
        case .bottom:
            return [UIRectCorner.bottomLeft, UIRectCorner.bottomRight]
        case .bottomLeft:
            return UIRectCorner.bottomLeft
        case .bottomRight:
            return UIRectCorner.bottomRight
        case .allCorners:
            return UIRectCorner.allCorners
        }
    }
}

extension LKGuideView {
    
    /// 显示动画
    private func showAnimation() {
        // 动画时长
        let animationDuration: TimeInterval = 0.2
        // 缩放比列
        let transScale: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
        // 初始Transform
        var startTransform: CGAffineTransform!
        
        switch contentView.arrowDirection {
        case .up:
            startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: 0.5*transScale.y*self.contentView.bounds.height))
        default:
            startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: -0.5*transScale.y*self.contentView.bounds.height))
        }
        
        self.contentView.transform = startTransform
        UIView.animate(withDuration: animationDuration, animations: {
            self.contentView.transform = .identity
        })
    }
    
    @objc private func hiddenAnimation() {
        self.guideViewNextBlock?()
        // 动画时长
        let animationDuration: TimeInterval = 0.1
        // 缩放比列
        let transScale: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
        // 初始Transform
        var endTransform: CGAffineTransform!
        
        switch contentView.arrowDirection {
        case .up:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: 0.5*transScale.y*self.contentView.bounds.height))
        default:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: -0.5*transScale.y*self.contentView.bounds.height))
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.alpha = 0
            self.contentView.transform = endTransform
        }) { (isFinish) in
            self.removeFromSuperview()
        }
    }
}

extension LKGuideView {
    public static func show(fromView: UIView, cornerType: GuideCornerType = .allCorners, cornerRadius: CGFloat = 4.rate, title: NSAttributedString?, content: NSAttributedString?) {
        let guideView = LKGuideView.init(fromView, cornerType, cornerRadius, title, content)
        guideView.alpha = 0
        
        UIApplication.shared.lk.legacyKeyWindow?.addSubview(guideView)
        
        UIView.animate(withDuration: 0.1) {
            guideView.alpha = 1
        }
    }
    
    public static func showAndReturn(fromView: UIView, cornerType: GuideCornerType = .allCorners, cornerRadius: CGFloat = 4.rate, title: NSAttributedString?, content: NSAttributedString?) -> LKGuideView {
        let guideView = LKGuideView.init(fromView, cornerType, cornerRadius, title, content)
        guideView.alpha = 0
        
        UIApplication.shared.lk.legacyKeyWindow?.addSubview(guideView)
        
        UIView.animate(withDuration: 0.1) {
            guideView.alpha = 1
        }
        return guideView
    }
}

