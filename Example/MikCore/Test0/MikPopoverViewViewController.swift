//
//  MikPopoverViewViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/23.
//

import UIKit

class MikPopoverViewViewController: MikBaseViewController {

    private let buttons: [UIButton] = stride(from: UIViewController.mik.safeAreaMax.top, through: UIScreen.main.bounds.height, by: 100).map({
        let button = UIButton(frame: CGRect(x: CGFloat.random(in: 20 ..< UIScreen.main.bounds.width - 100), y: $0, width: 80, height: 44))
        button.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        button.setTitle("test\($0)", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.addTarget(self, action: #selector(didClickOnTestButton(_:)), for: .touchUpInside)
        return button
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        buttons.forEach({ self.view.addSubview($0) })
    }
    
    @objc
    private func didClickOnTestButton(_ sender: UIButton) {
        if Int.random(in: 0 ..< 2) == 0 {
            MikDescPopoverView.descPopopverView(showIn: self, displayArrow: Int.random(in: 0 ..< 2) == 0, attributedMessage: NSAttributedString(string: "Your order on 1/23 will be cancelled. Your next order will arrive 1/30.", attributes: [.foregroundColor : UIColor.red, .font : UIFont.boldSystemFont(ofSize: 14)]), activeKeys: ["1/23", "1/30."], fromView: sender) { (text) in
                print("tap: \(text)")
            }
        }else {
            MikDescPopoverView.descPopopverView(showIn: self, displayArrow: Int.random(in: 0 ..< 2) == 0, message: "Your order on 1/23 will be cancelled. Your next order will arrive 1/30.", activeKeys: ["1/23", "1/30."], fromView: sender) { (text) in
                print("tap: \(text)")
            }
        }
    }

}
