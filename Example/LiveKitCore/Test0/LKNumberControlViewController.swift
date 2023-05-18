//
//  LKNumberControlViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
import SnapKit

class LKNumberControlViewController: LKBaseViewController {

    private lazy var numberControl: LKNumberControl = {
        let aNumberControl = LKNumberControl(config: {
            var aConfig = LKNumberControl.Config()
            aConfig.minValue = 5
            aConfig.maxValue = 10
            return aConfig
        }())
        aNumberControl.value = 5
        aNumberControl.valueChangedHandler = { (value) in
            print("LKNumberControl value changed: \(value)")
        }
        return aNumberControl
    }()
    
    private lazy var numberControl1: LKNumberControl = {
        let aNumberControl = LKNumberControl(config: nil)
        aNumberControl.value = 5
        aNumberControl.valueChangedHandler = { (value) in
            print("LKNumberControl value changed: \(value)")
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
