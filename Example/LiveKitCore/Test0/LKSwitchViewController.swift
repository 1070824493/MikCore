//
//  LKSwitchViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
import SnapKit

class LKSwitchViewController: LKBaseViewController {

    private lazy var switch_: LKSwitch = {
        let aSwitch = LKSwitch()
        aSwitch.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
        return aSwitch
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(switch_)
        
        switch_.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
    
    @objc
    private func switchValueChanged(_ sender: LKSwitch) {
        print("switchValueChanged: \(sender.isOn ? 1 : 0)")
    }

}
