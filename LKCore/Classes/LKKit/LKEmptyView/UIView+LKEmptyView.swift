//
//  UIView+LKEmptyView.swift
//  LKCore
//
//  Created by m7 on 2021/4/28.
//

import UIKit

public extension UIView {
    
    /// 显示刷新操作的缺省页
    /// - Parameters:
    ///   - offsetCenterY: 内容垂直方向上的偏移量
    ///   - handler: 点击按钮的回调
    func showEmptyForRefresh(offsetCenterY: CGFloat? = nil,
                             handler: LKEmptyView.ActionHandler?) {
        self.showEmpty(image: UIImage.image("lk_empty_sad"), title: "Oops..seems the system is unavailable now,\n please try again later", message: nil, buttonTitle: "Refresh", buttonStyle: .refresh, offsetCenterY: offsetCenterY, handler: handler)
    }
    
    /// 显示缺省页
    /// - Parameters:
    ///   - backgroundColor: 背景颜色
    ///   - image: 图片
    ///   - title: 标题
    ///   - message: 其它信息
    ///   - buttonTitle: 事件按钮标题
    ///   - buttonStyle: 事件按钮样式
    ///   - handler: 点击事件按钮的回调
    /// - Note: 显示缺省页之前会移除当前已存在的缺省页
    func showEmpty(backgroundColor: UIColor = UIColor.lk.color(.hexFFFFFF),
                   image: UIImage? = nil,
                   title: String? = nil,
                   message: String? = nil,
                   buttonTitle: String? = nil,
                   buttonStyle: LKEmptyValuesConfig.ButtonValues.Style = .redFill,
                   offsetCenterY: CGFloat? = nil,
                   handler: LKEmptyView.ActionHandler? = nil) {
        let valuesConfig: LKEmptyValuesConfig = {
            var config = LKEmptyValuesConfig()
            config.backgroundColor = backgroundColor
            
            if let image = image {
                config.imageValues = LKEmptyValuesConfig.ImageValues(image: image)
            }
            if let title = title {
                config.titleValues = LKEmptyValuesConfig.TitleValues(text: title)
            }
            if let message = message {
                config.messageValues = LKEmptyValuesConfig.MessageValues(text: message)
            }
            if let buttonTitle = buttonTitle {
                config.buttonValues = LKEmptyValuesConfig.ButtonValues(title: buttonTitle, style: buttonStyle)
            }
            return config
        }()
        
        self.showEmpty(valuesConfig: valuesConfig, offsetCenterY: offsetCenterY, handler: handler)
    }
    
    /// 显示缺省页
    /// - Parameters:
    ///   - valuesConfig: 配置
    ///   - offsetCenterY: 内容垂直方向上的偏移量
    ///   - handler: 点击按钮的回调
    func showEmpty(valuesConfig: LKEmptyValuesConfig,
                   offsetCenterY: CGFloat? = nil,
                   handler: LKEmptyView.ActionHandler? = nil) {
        self.removeEmptyView()
        
        let emptyView = LKEmptyView(valuesConfig: valuesConfig, offsetCenterY: offsetCenterY, handler: handler)
        
        self.addSubview(emptyView)
        
        emptyView.snp.makeConstraints { (make) in
            make.size.centerX.centerY.equalToSuperview()
        }
    }
    
    /// 移除缺省页
    func removeEmptyView() {
        self.subviews.forEach({
            if $0 is LKEmptyView {
                $0.removeFromSuperview()
            }
        })
    }
    
}
