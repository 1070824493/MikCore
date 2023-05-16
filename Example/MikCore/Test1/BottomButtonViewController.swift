//
//  BottomButtonViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/26.
//

import UIKit

class BottomButtonViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let item = MikBottomButtonView.init(titles: [ "oK", "add TO cart" ])
        item.setButton(isEnabled: false, index: 0)
        item.setButton(isEnabled: false, index: 1)
        self.view.addSubview(item)
        item.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(24.rate)
        }
        item.takeBottomButtonBlock = { (title, index) in
            print("title = \(title), index = \(index)")
        }
        
        let item1 = MikBottomButtonView.init(title: "Confirm")
//        item1.setButton(isEnabled: false, index: 0)
        self.view.addSubview(item1)
        item1.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(100.rate)
        }
        item1.takeBottomButtonBlock = { (title, index) in
            print("title = \(title), index = \(index)")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
