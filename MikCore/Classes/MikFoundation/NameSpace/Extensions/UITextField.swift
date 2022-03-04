//
//  UITextField.swift
//  MikFoundation
//
//  Created by m7 on 2021/8/31.
//

import Foundation
import UIKit

fileprivate var kLeftViewKey: Void?
fileprivate var kRightViewKey: Void?

public extension UITextField {
    
    typealias ActionHandler = () -> Void
        
    /// 设置’leftView‘
    /// - Parameters:
    ///   - image: 一般状态的图片
    ///   - selectedImage: 选中状态的图片
    ///   - handler: 点击’leftView‘的回调
    func setupLeftView(image: UIImage?, selectedImage: UIImage?, handler: ActionHandler?) {
        self.leftHandler = handler
        self.leftViewMode = .always
        self.leftView = {
            let aBtn = UIButton()
            aBtn.setImage(image, for: .normal)
            aBtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            aBtn.addTarget(self, action: #selector(didClickOnLeftButton(_:)), for: .touchUpInside)
            return aBtn
        }()
    }
    
    /// 设置’rightView‘
    /// - Parameters:
    ///   - image: 一般状态的图片
    ///   - selectedImage: 选中状态的图片
    ///   - handler: 点击’rightView‘的回调
    func setupRightView(image: UIImage?, selectedImage: UIImage?, handler: ActionHandler?) {
        self.rightHandler = handler
        self.rightViewMode = .always
        self.rightView = {
            let aBtn = UIButton()
            aBtn.setImage(image, for: .normal)
            aBtn.setImage(selectedImage, for: .selected)
            aBtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            aBtn.addTarget(self, action: #selector(didClickOnRightButton(_:)), for: .touchUpInside)
            return aBtn
        }()
    }
            
    /// 设置空白的’leftView‘
    /// - Parameter size: ’leftView‘的大小，默认为 CGSize(width: 16, height: 48)
    func setupLeftEmptyView(_ size: CGSize = CGSize(width: 16, height: 48)) {
        guard size != .zero else { return }
        self.leftViewMode = .always
        self.leftView = {
            let aView = UIView(frame: CGRect(origin: .zero, size: size))
            aView.isUserInteractionEnabled = false
            return aView
        }()
    }
    
    /// 设置空白的’rightView‘
    /// - Parameter size: ’rightView‘的大小，默认为 CGSize(width: 16, height: 48)
    func setupRightEmptyView(_ size: CGSize = CGSize(width: 16, height: 48)) {
        guard size != .zero else { return }
        self.rightViewMode = .always
        self.rightView = {
            let aView = UIView(frame: CGRect(origin: .zero, size: size))
            aView.isUserInteractionEnabled = false
            return aView
        }()
    }
    
    /// 设置密码框’rightView‘的样式
    /// - Parameters:
    ///   - image: 一般状态的图片
    ///   - selectedImage: 选中状态的图片
    ///   - handler: 点击’rightView‘的回调
    func setupSecureTextEntry(image: UIImage?, selectedImage: UIImage?, handler: ActionHandler?) {
        self.rightHandler = handler
        self.rightViewMode = .always
        self.rightView = {
            let aBtn = UIButton()
            aBtn.setImage(image, for: .normal)
            aBtn.setImage(selectedImage, for: .selected)
            aBtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
            aBtn.addTarget(self, action: #selector(didClickOnSecureButton(_:)), for: .touchUpInside)
            return aBtn
        }()
    }
    
}

fileprivate extension UITextField {
    
    private var leftHandler: ActionHandler? {
        get {
            return objc_getAssociatedObject(self, &kLeftViewKey) as? ActionHandler
        }
        set {
            objc_setAssociatedObject(self, &kLeftViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    private var rightHandler: ActionHandler? {
        get {
            return objc_getAssociatedObject(self, &kRightViewKey) as? ActionHandler
        }
        set {
            objc_setAssociatedObject(self, &kRightViewKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}

fileprivate extension UITextField {
    
    @objc
    private func didClickOnLeftButton(_ sender: UIButton) {
        sender.isSelected = !isSelected
        self.leftHandler?()
    }
    
    @objc
    private func didClickOnRightButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.rightHandler?()
    }
    
    @objc
    private func didClickOnSecureButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !self.isSecureTextEntry
        self.rightHandler?()
    }
    
}
