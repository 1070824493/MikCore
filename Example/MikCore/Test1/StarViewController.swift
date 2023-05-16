//
//  StarViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/21.
//

import UIKit
import SnapKit

class StarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        let starView = MikStarRateView()
//        starView.backgroundColor = .red
        starView.title = "&Up"
        starView.currentStarCount = 3
        self.view.addSubview(starView)
        starView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(140.0)
            make.left.equalToSuperview().inset(60.0)
            make.height.equalTo(20.0)
        }
        
        let starView1 = MikStarRateView()
//        starView.backgroundColor = .red
        starView1.isHiddenTitle = true
        starView1.currentStarCount = 3
        self.view.addSubview(starView1)
        starView1.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(200.0)
            make.left.equalToSuperview().inset(60.0)
            make.height.equalTo(50.0)
        }

        // Do any additional setup after loading the view.
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
