//
//  MikBaseViewController.swift
//  MikCore_Example
//
//  Created by 唐义 on 2021/12/26.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import UIKit

class MikBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "\(type(of: self))"
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
