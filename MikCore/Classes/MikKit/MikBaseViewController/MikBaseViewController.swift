//
//  MikBaseViewController.swift
//  ActiveLabel
//
//  Created by ty on 2022/4/6.
//

import UIKit


open class MikBaseViewController: UIViewController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.mik.general(.hexFFFFFF)
    }


    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    deinit {
        print("*** \(String(describing: self)) deinit ***♻️")
    }
    
}