//
//  BottomPopController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/26.
//

import UIKit

class BottomPopController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        for i in 0 ..< 2 {
            let btn = MikButton.init(style: .fillRed)
            btn.addTarget(self, action: #selector(btnAction(btn:)), for: UIControl.Event.touchUpInside)
            btn.tag = 1000 + i
            self.view.addSubview(btn)
            btn.snp.makeConstraints { (make) in
                make.size.equalTo(60.0)
                if i == 0 {
                    make.centerX.equalToSuperview().offset(-70)
                    make.centerY.equalToSuperview()
                } else {
                    make.centerX.equalToSuperview().offset(10)
                    make.centerY.equalToSuperview()
                }
            }
        }
    }
    
    @objc func btnAction(btn: UIButton) {
        if btn.tag == 1000 {
            let nav = MikBottomPopNavigationController.init(rootViewController: TestViewController())
            nav.addRightBarButtonItem(title: nil, image: UIImage(named: "mik_x"))
            self.present(nav, animated: true, completion: nil)
        } else {
            self.present(TestThreeViewController(), animated: true, completion: nil)
        }
    }
}
