//
//  UIButton.swift
//  SellerMobile
//  Created by m7 on 2021/4/8.
//

import UIKit
import Kingfisher


public extension LKNameSpace where Base: UIButton {
    
    enum ImageDirection {
      case left, right, top, bottom
    }
    
    /// 设置按钮图片所在位置(标题和图片需要在此之前设置好)
    /// - Parameters:
    ///   - direction: 图片位置
    ///   - space: 图片与标题的间距
    func setImageDirection(_ direction: ImageDirection, space: CGFloat) {
        guard let titleLabel = self.base.titleLabel, let image = self.base.imageView?.image else {
            return
        }
        
        let imageWidth: CGFloat = image.size.width
        let imageHeight: CGFloat = image.size.height
        let titleWidth = titleLabel.intrinsicContentSize.width
        let titleHeight = titleLabel.intrinsicContentSize.height
        
        let imageOffsetX = (imageWidth + titleWidth) / 2 - imageWidth / 2
        let imageOffsetY = (imageHeight + space) / 2
        let labelOffsetX = (imageWidth + titleWidth / 2) - (imageWidth + titleWidth) / 2
        let labelOffsetY = (titleHeight + space) / 2
        
        switch (direction) {
        case .left:
            self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2, bottom: 0, right: space / 2)
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: space / 2, bottom: 0, right: -space / 2)
            self.base.contentEdgeInsets = {
                let orginInsets = self.base.contentEdgeInsets
                return UIEdgeInsets(top: orginInsets.top, left: orginInsets.left + space / 2, bottom: orginInsets.bottom, right: orginInsets.right + space / 2)
            }()
            
        case .right:
            self.base.imageEdgeInsets = UIEdgeInsets(top: 0, left: titleWidth + space / 2, bottom: 0, right: -(titleWidth + space / 2))
            self.base.titleEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWidth + space / 2), bottom: 0, right: imageWidth + space / 2)
            self.base.contentEdgeInsets = {
                let orginInsets = self.base.contentEdgeInsets
                return UIEdgeInsets(top: orginInsets.top, left: orginInsets.left + space / 2, bottom: orginInsets.bottom, right: orginInsets.right + space / 2)
            }()
            
        case .top:
            self.base.imageEdgeInsets = UIEdgeInsets(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX)
            self.base.titleEdgeInsets = UIEdgeInsets(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX)
            self.base.contentEdgeInsets = {
                let orginInsets = self.base.contentEdgeInsets
                return UIEdgeInsets(top: orginInsets.top + imageOffsetY,
                                    left: orginInsets.left + (max(imageWidth, titleWidth) - (titleWidth + imageWidth)) / 2,
                                    bottom: orginInsets.bottom - max((imageHeight - titleHeight) / 2, 0) + labelOffsetY,
                                    right: orginInsets.right + (max(imageWidth, titleWidth) - (titleWidth + imageWidth)) / 2)
            }()
            
        case .bottom:
            self.base.imageEdgeInsets = UIEdgeInsets(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX)
            self.base.titleEdgeInsets = UIEdgeInsets(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX)
            self.base.contentEdgeInsets = {
                let orginInsets = self.base.contentEdgeInsets
                return UIEdgeInsets(top: orginInsets.top - max((imageHeight - titleHeight) / 2, 0) + labelOffsetY,
                                    left: orginInsets.left + (max(imageWidth, titleWidth) - (titleWidth + imageWidth)) / 2,
                                    bottom: orginInsets.bottom + imageOffsetY,
                                    right: orginInsets.right + (max(imageWidth, titleWidth) - (titleWidth + imageWidth)) / 2)
            }()
        }
    }
    
}

// MARK: - Kingfisher
public extension LKNameSpace where Base: UIButton {
        
    /// 加载网络图片
    /// - Parameters:
    ///   - urlStr: 图片链接
    ///   - state: 状态
    ///   - placeholder: 默认图片
    @discardableResult
    func setImg(with urlStr: String?, state: UIButton.State, placeholder: UIImage? = nil) -> DownloadTask? {
        if let urlStr = urlStr, let url = URL(string: urlStr) {
            return self.base.kf.setImage(with: url, for: state, placeholder: placeholder)
        }else{
            self.base.setImage(placeholder, for: state)
        }
        return nil
    }
    
    /// 加载背景图片
    /// - Parameters:
    ///   - urlStr: 图片链接
    ///   - state: 状态
    ///   - placeholder: 默认图片
    @discardableResult
    func setBackgroundImage(with urlStr: String?, state: UIButton.State, placeholder: UIImage? = nil) -> DownloadTask? {
        if let urlStr = urlStr,let url = URL(string: urlStr) {
            return self.base.kf.setBackgroundImage(with: url, for: state,placeholder: placeholder)
        }else{
            self.base.setBackgroundImage(placeholder, for: state)
        }
        return nil
    }
    
}
