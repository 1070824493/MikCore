//
//  MikNumberControlViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
import SnapKit

class MikNumberControlViewController: UIViewController {

    private lazy var numberControl: MikNumberControl = {
        let aNumberControl = MikNumberControl(config: {
            var aConfig = MikNumberControl.Config()
            aConfig.minValue = 5
            aConfig.maxValue = 10
            return aConfig
        }())
        aNumberControl.value = 5
        aNumberControl.isEnabled = false
        aNumberControl.valueChangedHandler = { (value) in
            print("MikNumberControl value changed: \(value)")
        }
        return aNumberControl
    }()
    
    private lazy var numberControl1: MikNumberControl = {
        let aNumberControl = MikNumberControl(config: nil)
        aNumberControl.value = 4
        aNumberControl.valueChangedHandler = { [weak self] (value) in
            print("MikNumberControl value changed: \(value)")
            self?.numberControl.isEnabled = value > 5
        }
        return aNumberControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(numberControl)
        view.addSubview(numberControl1)
        
        numberControl.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        numberControl1.snp.makeConstraints { (make) in
            make.centerX.equalTo(numberControl)
            make.top.equalTo(numberControl.snp.bottom).offset(20)
        }
    }

}
