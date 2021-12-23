//
//  UIView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/5.
//

import UIKit


private var kGradientLayerKey: Void?
private var kDashedBoardLayerKey: Void?

// MARK: - Utils
public extension MikNameSpace where Base: UIView {
    
    /// identifier
    /// - Returns: identifier
    func identifier() ->String {        
        return "\(String(describing: Base.Type.self)).identifier"
    }
    
    /// identifier
    /// - Returns: identifier
    static func identifier() -> String {
        return "\(String(describing: Base.Type.self)).identifier"
    }
    
    /// 视图所在控制器
    func viewController() -> UIViewController? {
        var n = self.base.next
        while n != nil {
            if (n is UIViewController) { return n as? UIViewController }
            n = n?.next
        }
        return nil
    }
    
    /// 为View任意边添加圆角
    /// - Parameters:
    ///   - size: 视图大小
    ///   - rounding: 边
    ///   - radius: 圆角
    func setCorners(size: CGSize? = nil, radius: CGFloat, rectCorner: UIRectCorner = .allCorners) {
        let bounds = CGRect(origin: .zero, size: size ?? self.base.bounds.size)
        if bounds.size.width != 0 && bounds.size.height != 0 {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: radius, height: radius))
            let layer = CAShapeLayer()
            layer.frame = bounds
            layer.path = path.cgPath
            self.base.layer.mask = layer
        } else {
            // 如果没有获取到view的bounds时
            DispatchQueue.main.async {
                self.setCorners(size: size, radius: radius, rectCorner: rectCorner)
            }
        }
    }
    
    /// 添加阴影效果
    func setShadow(rect: CGRect? = nil, color: UIColor = UIColor.black, opacity: Float = 0.5, offset: CGSize = CGSize(width: 0, height: 0), radius: CGFloat = 2.0) {
        let bounds = rect ?? self.base.bounds
        if bounds.size != .zero {
            // 添加阴影
            self.base.layer.shadowColor = color.cgColor
            // 阴影的透明度
            self.base.layer.shadowOpacity = opacity
            // 阴影的偏移
            self.base.layer.shadowOffset = offset
            // 阴影的偏移半径
            self.base.layer.shadowRadius = radius
            // 避免离屏渲染带来卡顿
            self.base.layer.shadowPath = UIBezierPath(rect: bounds
            ).cgPath
        } else {
            // 如果没有获取到view的bounds时
            DispatchQueue.main.async {
                self.setShadow(rect: rect, color: color, opacity: opacity, offset: offset, radius: radius)
            }
        }
    }
    
    /// 添加圆角的阴影效果
    func setShadowWithCorners(size: CGSize, roundingCorners: UIRectCorner = [.allCorners], cornerRadius: CGFloat = 8.rate, shadowColor: UIColor = UIColor.mik.hex(0x000000, alpha: 0.2), shadowOpacity: Float = 1, shadowOffset: CGSize = CGSize(width: 0, height: 1), shadowRadius: CGFloat = 6.0) {
        // 阴影的Path
        let shadowPath = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        // 添加阴影
        self.base.layer.shadowColor = shadowColor.cgColor
        // 阴影的透明度
        self.base.layer.shadowOpacity = shadowOpacity
        // 阴影的偏移
        self.base.layer.shadowOffset = shadowOffset
        // 阴影的偏移半径
        self.base.layer.shadowRadius = shadowRadius
        // 避免离屏渲染带来卡顿
        self.base.layer.shadowPath = shadowPath.cgPath
    }

    /// 设置虚线边框
    /// - Parameters:
    ///   - frame: 虚线Frame，默认为视图的bounds
    ///   - lineWidth: 线宽
    ///   - lenth: 虚线长度
    ///   - space: 虚线间间隔
    ///   - cornerRadius: 圆角
    ///   - color: 虚线颜色
    func setDashedBoard(frame: CGRect? = nil, lineWidth: CGFloat, lenth: Float, space: Float, cornerRadius: CGFloat, color: UIColor) -> CAShapeLayer {
        func setDashedBoardLayer(_ layer: CAShapeLayer) {
            layer.frame = frame ?? self.base.bounds
            layer.path = UIBezierPath(roundedRect: layer.bounds, cornerRadius: cornerRadius).cgPath
            layer.lineWidth = lineWidth
            layer.lineDashPattern = [NSNumber(value: lenth), NSNumber(value: space)]
            layer.lineDashPhase = 0.1
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = color.cgColor
                        
            self.base.layer.cornerRadius = cornerRadius
            self.base.layer.addSublayer(layer)
        }
        
        
        if let dashedBoardLayer = objc_getAssociatedObject(self, &kDashedBoardLayerKey) as? CAShapeLayer {
            setDashedBoardLayer(dashedBoardLayer)
            return dashedBoardLayer
        }else {
            let dashedBoardLayer = CAShapeLayer()
            setDashedBoardLayer(dashedBoardLayer)
            objc_setAssociatedObject(self, &kDashedBoardLayerKey, dashedBoardLayer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return dashedBoardLayer
        }
    }
    
    /// 视图添加颜色渐变
    /// - Parameters:
    ///   - colors: 颜色数组，定义渐变层的各个颜色
    ///   - startPoint: 渲染的起始位置
    ///   - endPoint: 渲染的终止位置
    /// - Returns: CAGradientLayer
    /// Note：如果控件位置都是通过约束去设置的，必须设置完约束后，再设置渐变色，否则就会设置失败
    @discardableResult
    func setGradient(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) -> CAGradientLayer {
        func setGradientLayer(_ layer: CAGradientLayer) {
            self.base.layoutIfNeeded()
            var colorArr = [CGColor]()
            for color in colors {
                colorArr.append(color.cgColor)
            }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.frame = self.base.bounds
            CATransaction.commit()
            
            layer.colors = colorArr
            layer.startPoint = startPoint
            layer.endPoint = endPoint
        }
        
        if let gradientLayer = objc_getAssociatedObject(self, &kGradientLayerKey) as? CAGradientLayer {
            setGradientLayer(gradientLayer)
            return gradientLayer
        }else {
            let gradientLayer = CAGradientLayer()
            self.base.layer.insertSublayer(gradientLayer , at: 0)
            setGradientLayer(gradientLayer)
            objc_setAssociatedObject(self, &kGradientLayerKey, gradientLayer, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return gradientLayer
        }
    }
    
    /// 截图
    /// - Parameter rect: 要截取的区域, 默认为试图自身大小
    func shot(rect: CGRect? = nil) -> UIImage? {
        let scale = UIScreen.main.scale
        let bRect: CGRect = {
            guard let rect = rect else { return self.base.bounds }
            return rect
        }()
        
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(self.base.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        self.base.layer.render(in: context)
        guard let allImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage else { return nil }
        
        let cRect = CGRect(x: bRect.origin.x * scale, y: bRect.origin.y * scale, width: bRect.size.width * scale , height: bRect.size.height * scale)
        guard let cgImage = allImage.cropping(to: cRect) else { return nil }
        
        return UIImage(cgImage: cgImage)
    }
    
}
