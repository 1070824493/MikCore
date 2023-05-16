//
//  MikTextFieldFormatterViewViewController.swift
//  MikCore
//
//  Created by m7 on 2021/9/2.
//

import UIKit

private let phoneStyle: MikTextFieldFormatterView.CustomFormatterStyle = .phone(lenth: 11)

class MikTextFieldFormatterViewViewController: UIViewController {
    
    private let textFieldProxy = CustomTextFieldVaildateProxy(style: phoneStyle)
    
    private var tapCount = -1
    
    // MikFormatterTextField
    private lazy var normalTextField: MikFormatterTextField = {
        let aTextField = MikFormatterTextField(formatteTuple: ([4], "-"))
        aTextField.backgroundColor = .white
        aTextField.attributedPlaceholder = NSAttributedString(string: "xxxx-xxxx...", attributes: [.foregroundColor : UIColor.mik.text(.hexAEAEAE)])
        return aTextField
    }()
    
    // 手机号格式化 + 输入校验（可自定义校验规则）
    private lazy var phoneTextFieldFormatterView: MikTextFieldFormatterView = {
        let aTextFieldFormatterView = MikTextFieldFormatterView(style: phoneStyle)
        aTextFieldFormatterView.textField.delegate = textFieldProxy
        aTextFieldFormatterView.title = "Phone number"
        aTextFieldFormatterView.textField.keyboardType = .numberPad
        aTextFieldFormatterView.textField.attributedPlaceholder = NSAttributedString(string: "点击屏幕切换更多样式", attributes: [.foregroundColor : UIColor.mik.text(.hexAEAEAE)])
        aTextFieldFormatterView.textField.addTarget(textFieldProxy, action: textFieldProxy.editChangedSelector, for: .editingChanged)
        aTextFieldFormatterView.validateResult = .tips(msg: "点击屏幕切换更多样式")
        return aTextFieldFormatterView
    }()
    
    // 自定义格式化样式 + 密码框
    private lazy var customFieldFormatterView: MikTextFieldFormatterView = {
        let aTextFieldFormatterView = MikTextFieldFormatterView(formatteTuple: ([1, 2, 3, 4], "/"), spacesTuple: (0, 0))
        aTextFieldFormatterView.title = "Custom formatter"
        aTextFieldFormatterView.textField.isSecureTextEntry = true
        aTextFieldFormatterView.textField.setupSecureTextEntry(image: UIImage.image("mik_text_success"), selectedImage: UIImage.image("mik_text_error"), handler: nil)
        return aTextFieldFormatterView
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: [normalTextField, phoneTextFieldFormatterView, customFieldFormatterView])
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 0
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupSubviews()
        setupSubviewsConstraints()
        
        // ’rx.text_‘ 替代 ’rx.text‘
        _ = normalTextField.rx.text_.subscribe(onNext: { print("rx observer value \($0 ?? "")") })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.view.endEditing(true)
//        self.phoneTextFieldFormatterView.validateResult = .ok(msg: "Please make sure to call this after your primary view controller has been initialized.")
        tapCount += 1
        switch tapCount % 4 {
        case 0:
            self.phoneTextFieldFormatterView.validateResult = .ok(msg: "validate message")
        case 1:
            self.phoneTextFieldFormatterView.validateResult = .error(msg: "Tap self.view change validate messageTap self.view change validate messageTap self.view change validate message")
        case 2:
            self.phoneTextFieldFormatterView.validateResults = [.tips(msg: "validate message 0validate message 0validate message 0"), .error(msg: "validate message 1"), .ok(msg: "validate message 2"), .error(msg: "validate message 2")]
        default:
            self.phoneTextFieldFormatterView.validateResult = nil
        }
        
        print("你输入的手机号为：", phoneTextFieldFormatterView.textField.text_ ?? "")
        print("你输入的值为：", customFieldFormatterView.textField.text_ ?? "")
    }

}

// MARK: - Assistant
extension MikTextFieldFormatterViewViewController {
    
    private func configure() {
        view.backgroundColor = UIColor.mik.general(.hexF6F6F6)
    }
    
    private func setupSubviews() {
        view.addSubview(mStackView)
    }
    
    private func setupSubviewsConstraints() {
        mStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(100)
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
}
