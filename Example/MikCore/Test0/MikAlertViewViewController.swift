//
//  MikAlertViewViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/23.
//

import UIKit
import SnapKit
import ZLPhotoBrowser

class MikAlertViewViewController: UIViewController {
    
    enum AlertStyle: CaseIterable {
        case default0, default1, default2, default3, default4, default5, default6
        
        var title: String? {
            switch self {
            case .default0, .default2, .default3, .default4, .default6: return "Skip next subscription"
            default: return nil
            }
        }
        
        var message: String? {
            switch self {
            case .default0, .default1, .default3, .default4: return "Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30.Your order on 1/23 will be cancelled. Your next order will arrive 1/30."
            case .default5: return "This message will not be logged again."
            default: return nil
            }
        }
        
        var attributedMessage: NSAttributedString? {
            NSAttributedString(string: "Your order Your order Your order on 1/23 will be cancelled. Your next order will arrive 1/30.", attributes: [.font: UIFont.mik.font(.nunitoSansBold, size: 14), .foregroundColor: UIColor.mik.text(.hexCF1F2E)])
        }
        
    }
    
    private var inputViewsTuple: MikInputAlertView.InputViewsTuple?
    
    private weak var twoStepAlertViewController: MikTwoStepAlertViewController?

    private let buttons: [UIButton] = AlertStyle.allCases.map({
        let button = UIButton()
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.setTitle("test \($0)", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(didClockOnTestButton(_:)), for: .touchUpInside)
        return button
    })
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: buttons)
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 30
        aStackView.distribution = .fillEqually
        return aStackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(mStackView)
       
        mStackView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    private func didClockOnTestButton(_ sender: UIButton) {
        let style = AlertStyle.allCases[self.buttons.firstIndex(of: sender)!]
        
        // 常用的‘Cancel’样式
        let cancelAction = MikAlertAction.cancelAction(title: "No!") {
            MikPrint("click on cancel button......")
        }
        
        // 常用的‘Confirm’样式
        let confirmAction = MikAlertAction.confirmAction(title: "Confirm") {
            MikPrint("click on ok button......")
        }
        
        // 其它样式
        let otherStyleAction = MikAlertAction.action(title: "other", style: .normal) {
            MikPrint("click on other button......")
        }
        
        // 自定义样式
        let customAction: MikAlertAction = {
            let aAction = MikAlertAction { (aBtn) in
                aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hex87CEFA)), for: .normal)
                aBtn.setBackgroundImage(UIImage.mik.image(UIColor.mik.general(.hex87CEFA, alpha: 0.5)), for: .highlighted)
                aBtn.layer.cornerRadius = 25
                aBtn.layer.masksToBounds = true
                aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14)
                aBtn.setTitleColor(UIColor.mik.text(.hexFFFFFF), for: .normal)
                aBtn.setTitle("NotHidden", for: .normal)
                aBtn.setImage(UIImage.image("nav_del"), for: .normal)
                aBtn.mik.setImageDirection(.left, space: 4)
            } handle: {
                MikPrint("click on ok custom...but it's not hidden")
            }
            
            aAction.isHiddenEnable = false
            return aAction
        }()
        
        let inputHiddenAction = MikAlertAction.confirmAction(title: "hidden") { [weak self] in
            MikPrint("input value is: \(String(describing: self?.inputViewsTuple?.inputView.text))")
            self?.inputViewsTuple?.controller.hidden(nil)
        }
        
        let actions: [MikAlertAction] = {
            switch style {
            case .default0: return [otherStyleAction, confirmAction]
            case .default1: return [cancelAction]
            case .default2: return [confirmAction]
            case .default3: return [cancelAction, confirmAction, confirmAction]
            case .default4: return [cancelAction, customAction]
            case .default5: return [inputHiddenAction, confirmAction]
            case .default6: return []
            }
        }()
        
        if style == .default5 {
            self.inputViewsTuple = MikInputAlertView.inputAlertView(title: style.title, message: style.message, placeholder: "Input any message", showInView: self, actions: actions)
        }else if style == .default4 {
            MikAlertView.alertView(title: style.title, attributedMessage: style.attributedMessage, showInView: self, actions: actions)
        }else if style == .default6 {
            self.twoStepAlertViewController = MikTwoStepAlertView.alertTwoStepView(title: style.title, twoStepType: .phone("1231231234"), showInView: self, getCode: { [weak self] in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // 模拟网络请求返回
                    self?.twoStepAlertViewController?.isCountDown = true
                    self?.twoStepAlertViewController?.updateCodeValidateResult(validateResult: .error(msg: "test"))
                }
            }, submit: { code in
                print("input code: \(code ?? "")")
            })
            self.twoStepAlertViewController?.cancelCallback { [weak self] in
                self?.twoStepAlertViewController?.hidden(nil)
                print("cancel action")
            }
        }else {
            MikAlertView.alertView(title: style.title, message: style.message, showInView: self, actions: actions)
        }
    }

}
