//
//  LKAlertViewViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/23.
//

import UIKit
import SnapKit
import ZLPhotoBrowser


class LKAlertViewViewController: LKBaseViewController {
    
    enum AlertStyle: CaseIterable {
        case default0, default1, default2, default3, default4, default5
        
        var title: String? {
            switch self {
            case .default0, .default2, .default3, .default4: return "Skip next subscription"
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
            NSAttributedString(string: "Your order Your order Your order on 1/23 will be cancelled. Your next order will arrive 1/30.", attributes: [.font: UIFont.lk.font(.nunitoSansBold, size: 14), .foregroundColor: UIColor.lk.text(.hexCF1F2E)])
        }
        
    }
    
    private var inputViewsTuple: LKInputAlertView.InputViewsTuple?

    private let buttons: [UIButton] = AlertStyle.allCases.map({
        let button = UIButton()
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.setTitle("test \($0)", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(LKAlertViewViewController.self, action: #selector(didClockOnTestButton(_:)), for: .touchUpInside)
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
        let cancelAction = LKAlertAction.cancelAction(title: "No!") {
            print("click on cancel button......")
        }
        
        // 常用的‘Confirm’样式
        let confirmAction = LKAlertAction.confirmAction(title: "Confirm") {
            print("click on ok button......")
        }
        
        // 其它样式
        let otherStyleAction = LKAlertAction.action(title: "other", style: .normal) {
            print("click on other button......")
        }
        
        // 自定义样式
        let customAction: LKAlertAction = {
            let aAction = LKAlertAction { (aBtn) in
                aBtn.setBackgroundImage(UIImage.lk.image(UIColor.lk.color(.hex87CEFA)), for: .normal)
                aBtn.setBackgroundImage(UIImage.lk.image(UIColor.lk.color(.hex87CEFA, alpha: 0.5)), for: .highlighted)
                aBtn.layer.cornerRadius = 25
                aBtn.layer.masksToBounds = true
                aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 14)
                aBtn.setTitleColor(UIColor.lk.text(.hexFFFFFF), for: .normal)
                aBtn.setTitle("NotHidden", for: .normal)
                aBtn.setImage(UIImage.image("nav_del"), for: .normal)
                aBtn.lk.setImageDirection(.left, space: 4)
            } handle: {
                print("click on ok custom...but it's not hidden")
            }
            
            aAction.isHiddenEnable = false
            return aAction
        }()
        
        let inputHiddenAction = LKAlertAction.confirmAction(title: "hidden") { [weak self] in
            print("input value is: \(String(describing: self?.inputViewsTuple?.inputView.text))")
            self?.inputViewsTuple?.controller.hidden(nil)
        }
        
        let actions: [LKAlertAction] = {
            switch style {
            case .default0: return [otherStyleAction, confirmAction]
            case .default1: return [cancelAction]
            case .default2: return [confirmAction]
            case .default3: return [cancelAction, confirmAction, confirmAction]
            case .default5: return [inputHiddenAction, confirmAction]
            default: return [cancelAction, customAction]
            }
        }()
        
        if style == .default5 {
            self.inputViewsTuple = LKInputAlertView.inputAlertView(title: style.title, message: style.message, placeholder: "Input any message", showInView: self, actions: actions)
        }else if style == .default4 {
            LKAlertView.alertView(title: style.title, attributedMessage: style.attributedMessage, showInView: self, actions: actions)
        }else {
            LKAlertView.alertView(title: style.title, message: style.message, showInView: self, actions: actions)
        }
    }

}
