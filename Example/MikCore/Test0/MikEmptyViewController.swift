//
//  MikEmptyViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/21.
//

import UIKit
import MikCore

class MikEmptyViewController: MikBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        
        // 一般的调用方法
        self.view.showEmpty(image: UIImage(named: "tabbar_dash_n"), title: "No reviews yet", message: "Please click here to select a product group for this Featured Listing section.", buttonTitle: "Retry", buttonStyle: .blackFill, offsetCenterY: 0) {
            MikLogger.debug("handler call back")
        }
        
        // 全视图响应点击事件
//        self.view.showEmpty(valuesConfig: {
//            var config = MikEmptyValuesConfig()
//            config.imageValues = MikEmptyValuesConfig.ImageValues(image: UIImage(named: "tabbar_dash_n")?.withRenderingMode(.alwaysTemplate), tinColor: UIColor.red)
//            config.titleValues = MikEmptyValuesConfig.TitleValues(text: "No reviews yet", textColor: UIColor.blue)
//            config.messageValues = MikEmptyValuesConfig.MessageValues(text: "Please click here to select a product group for this Featured Listing section.")
//            config.tapHandler = { [weak self] in
//                MikLog.debug("handler call back")
//            }
//            return config
//        }())
        
        // 刷新样式
//        self.view.showEmptyForRefresh(handler: <#T##MikEmptyView.ActionHandler?##MikEmptyView.ActionHandler?##() -> Void#>)
        
        // 自定义样式的调用方法
//        self.view.showEmpty(valuesConfig: <#T##MikEmptyValuesConfig#>, offsetCenterY: <#T##CGFloat?#>, handler: <#T##MikEmptyView.ActionHandler?##MikEmptyView.ActionHandler?##() -> Void#>)
    }
    
}
