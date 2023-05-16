//
//  MikFilterViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/23.
//

import UIKit
import SnapKit

class MikFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let filterView = MikFilterViewCell()
        filterView.title = "title"
        filterView.isShowLayerLine = true
        filterView.image = UIImage.init(named: "mik_alarm")
        self.view.addSubview(filterView)
        filterView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40.rate)
            make.top.equalToSuperview().inset(320.0)
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
