//
//  TestViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/26.
//

import UIKit

class TestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        if let nav = self.navigationController as? MikBottomPopNavigationController {
            nav.leftTitle = "test123"
        }
//        nav.addRightBarButtonItem(image: UIImage(named: "mik_x"))
        
        let btn = UIButton.init(type: .custom)
        btn.setTitle("下一个", for: .normal)
        btn.backgroundColor = .red
        btn.addTarget(self, action: #selector(btnAction), for: UIControl.Event.touchUpInside)
        self.view.addSubview(btn)
        btn.snp.makeConstraints { (make) in
            make.size.equalTo(100)
            make.center.equalToSuperview()
        }
    }
    
    @objc func btnAction() {
        let controller = TestTwoViewController()
        self.navigationController?.pushViewController(controller, animated: true)
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
