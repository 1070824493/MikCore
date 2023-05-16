//
//  UIImage.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit

public extension UIImage {
    
    static func image(_ name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.mik.default, compatibleWith: nil)
    }
    
}

// MARK: - Utils
public extension MikNameSpace where Base: UIImage {
    
    /// 颜色生产图片
    /// - Parameters:
    ///   - color: 图片颜色
    ///   - size: 图片尺寸
    static func image(_ color: UIColor, size: CGSize = CGSize(width: 4, height: 4)) -> UIImage? {
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        return image
    }
    
    /// 将当前图像着色为特定颜色
    /// - Parameter color: 颜色
    /// - Returns: 被着色的图片
    func imageWithColor(_ color: UIColor) -> UIImage? {
        guard let cgImage = self.base.cgImage else { return nil }
        
        defer { UIGraphicsEndImageContext() }
        
        UIGraphicsBeginImageContextWithOptions(self.base.size, false, self.base.scale)
        
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: 0, y: self.base.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.setBlendMode(.normal)
        
        let rect = CGRect(x: 0, y: 0, width: self.base.size.width, height: self.base.size.height)
        context?.clip(to: rect, mask: cgImage)
        color.setFill()
        context?.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        return newImage
    }
    
    /// 设置圆角
    /// - Parameters:
    ///   - size: 大小, 默认为自身尺寸
    ///   - cornerRadii: 半径，默认为自身搞定的一半
    ///   - rectCorner: 圆角位置，默认全部
    ///   - borderWidth: 边框线宽，默认为0
    ///   - borderColor: 边框颜色，默认无
    /// - Returns: 圆角处理后的图片
    func setCorner(size: CGSize?, cornerRadii: CGFloat?, rectCorner: UIRectCorner = .allCorners, borderWidth: CGFloat = 0.0, borderColor: UIColor = .clear) -> UIImage? {
        let bSize: CGSize = {
            guard let size = size else { return self.base.size }
            return size
        }()
        
        let bCornerRadii: CGFloat = {
            guard let cornerRadii = cornerRadii else { return bSize.height * 0.5 }
            return cornerRadii
        }()
                
        return UIGraphicsImageRenderer(size: bSize).image { (context) in
            let rect = CGRect(origin: .zero, size: bSize)
            let path = UIBezierPath.init(roundedRect: rect, byRoundingCorners: rectCorner, cornerRadii: CGSize(width: bCornerRadii - borderWidth, height: bCornerRadii - borderWidth))
            context.cgContext.addPath(path.cgPath)
            context.cgContext.clip()
            
            self.base.draw(in: rect)
            
            borderColor.setStroke()
            path.stroke()
        }
    }
    
    /**
    /// 等比例缩放压缩
    func scaleCompressToFitSize(maxSize: CGSize = CGSize(width: 1080.0, height: 1080.0)) -> Data? {
        let rate = min(maxSize.width / self.base.size.width, maxSize.height / self.base.size.height)
        
        guard rate < 1 else {
            return self.base.jpegData(compressionQuality: 1)
        }
        
        let bSize = CGSize(width: self.base.size.width * rate, height: self.base.size.height * rate)
        
        let rendererFormat = UIGraphicsImageRendererFormat()
        let renderer = UIGraphicsImageRenderer(size: bSize, format: rendererFormat)
        return renderer.jpegData(withCompressionQuality: 0.5) { (context) in
            self.base.draw(in: CGRect(origin: .zero, size: bSize))
        }
    }
     */
    
}

// MARK: - 压缩图片相关
public extension MikNameSpace where Base: UIImage {
    
    enum CompressLevel {
        case gb(Float), mb(Float), kb(Float), byte(Float)
        
        var bytes: Float {
            switch self {
            case .gb(let value): return value * 1024 * 1024 * 1024
            case .mb(let value): return value * 1024 * 1024
            case .kb(let value): return value * 1024
            case .byte(let value): return value
            }
        }
    }
        
    /// 压缩图片
    /// - Parameter level: 最终大小上限，默认为 20MB
    /// - Returns: 压缩后的’Data‘
    func compressToBytes(_ level: CompressLevel = .mb(20)) -> Data? {
        var bImage: UIImage = self.base
        var bData: Data?
        var bBytes: Float = 0
        var quality: CGFloat = 1
        let step: CGFloat = 0.1
        
        repeat {
            if quality < step {
                quality = 1
                if let aImage = self.scaleSize(CGSize(width: bImage.size.width * 0.8, height: bImage.size.height * 0.8)) {
                    bImage = aImage
                }else { break }
            }
            
            bData = bImage.jpegData(compressionQuality: quality)
            bBytes = Float(bData?.count ?? 0)
            quality -= step
        } while (bBytes > level.bytes && quality > 0)
        
        return bData
    }
    
    
    /// 缩放到目标尺寸大小
    /// - Parameter size: 目标尺寸
    /// - Returns: 缩放后的图片
    func scaleSize(_ size: CGSize) -> UIImage? {
        let rate = min(size.width / self.base.size.width, size.height / self.base.size.height)
        
        guard rate < 1 else { return self.base }
        
        let bSize = CGSize(width: self.base.size.width * rate, height: self.base.size.height * rate)
        
        UIGraphicsBeginImageContext(bSize)
        self.base.draw(in: CGRect(origin: .zero, size: bSize))
        let bImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return bImage
    }
    
}

