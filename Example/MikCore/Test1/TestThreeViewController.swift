//
//  TestThreeViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/5/10.
//

import UIKit

class TestThreeViewController: MikBottomPopViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .red
        // Do any additional setup after loading the view.
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
