//
//  DropBoxViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/26.
//

import UIKit
import SnapKit

class DropBoxViewController: UIViewController {
    
    var dataArray: [DropBoxModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        // Do any additional setup after loading the view.
        
        self.createDatas()
        
        let boxView = MikDropBoxView()
        boxView.leftTitle = "Modal Title"
        boxView.leftTitleFont = UIFont.mik.font(.nunitoSansBold, size: 14.0)
        boxView.rightTitle = "Best Match"
        boxView.itemHeight = 44.rate
        boxView.dataArray = dataArray
        self.view.addSubview(boxView)
        boxView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().inset(100.rate)
            make.height.equalTo(52.rate)
        }
        boxView.takeDropBoxSelected = { (index, model) in
            
        }
    }
    

    func createDatas() {
        let titles = [ "Best Seller", "Best Match", "New Arrivals", "Latest to Newest", "Newest to Latest", "Price: Low to High", "Price: High to Low", "Rating: High to Low" ]
        self.dataArray = titles.map({ (title) -> DropBoxModel in
            let model = DropBoxModel()
            model.title = title
            model.isSelected = false
            return model
        })
    }

}
