//
//  TestListContraintsViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit

class TestListContraintsViewController: LKBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lk.rgb(Int.random(in: 0 ... 255), Int.random(in: 0 ... 255), Int.random(in: 0 ... 255))
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
    }

}

extension TestListContraintsViewController: LKSegmentedListContainerViewListDelegate {
    
    func listView() -> UIView {
        return self.view
    }
    
}
