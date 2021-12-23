//
//  MikPickerViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/28.
//

import UIKit
import SnapKit

public extension MikPickerViewController {
    
    /// 创建并显示PickerView
    /// - Parameters:
    ///   - viewController: 承载控制器
    ///   - title: 标题
    ///   - items: pickView 显示的内容集
    ///   - customCancel: 自定义取消按钮
    ///   - customConfirm: 自定义确定按钮
    ///   - confirmHandler: 选择结果回调
    static func pickerView(showIn viewController: UIViewController?, title: String? = nil, items: [[MikPickerItem]], customConfirm: CustomButtonCallback? = nil, confirmHandler: SelectedCallbacll?) {
        guard let viewController = viewController else { return }
        
        let pickerViewController = MikPickerViewController(title: title, items: items, customConfirm: customConfirm)
        pickerViewController.confirmHandler = confirmHandler
        viewController.present(pickerViewController, animated: true, completion: nil)
    }
    
}

public class MikPickerViewController: MikBottomPopViewController {
    
    public override var popupHeight: CGFloat { contentView.systemLayoutSizeFitting(UIScreen.main.bounds.size).height }
    
    public var confirmHandler: SelectedCallbacll?
        
    private let customConfirm: CustomButtonCallback?
    private let titleText: String?
    private let items: [[MikPickerItem]]
    
    private lazy var contentView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.mik.general(.hexFFFFFF)
        return aView
    }()
    
    private lazy var pickerView: MikPickerView = {
        let aPickerView = MikPickerView(title: titleText, items: items, customConfirm: customConfirm)
        aPickerView.confirmHandler = { [weak self] (indexPaths) in
            self?.dismiss(animated: true, completion: {
                self?.confirmHandler?(indexPaths)
            })
        }
        return aPickerView
    }()
    
    
    required init(title: String?, items: [[MikPickerItem]], customConfirm: CustomButtonCallback? = nil) {
        self.titleText = title
        self.items = items
        self.customConfirm = customConfirm
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }    

}

// MARK: - Assistant
extension MikPickerViewController {
    
    private func configure() {}
    
    private func setupSubviews() {
        contentView.addSubview(pickerView)
        view.addSubview(contentView)
    }
    
    private func setupSubviewsConstraints() {
        contentView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
