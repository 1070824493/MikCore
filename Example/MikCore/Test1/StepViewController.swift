//
//  StepViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/20.
//

import UIKit
import SnapKit

class StepViewController: UIViewController {
    
    private var index = 0
    
    private lazy var step2View: MikStepView = {
         return MikStepView.init(titles: [ "step1", "step2" ])
    }()
    
    private lazy var stepView: MikStepView = {
         return MikStepView.init(titles: [ "step1", "step2", "step3", "step4", "step5", "step6" ])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        self.view.addSubview(stepView)
        stepView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(180.0)
            make.left.right.equalToSuperview()
        }
        
        self.view.addSubview(step2View)
        step2View.snp.makeConstraints { (make) in
            make.top.equalTo(stepView.snp.bottom).offset(60)
            make.left.right.equalToSuperview()
        }
        
        let button = UIButton.init(type: .custom)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = .black
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview().inset(40.0)
            make.height.equalTo(50.0)
        }
    }
    
    
    @objc func buttonAction() {
        index += 1
        if index > 5 {
            index = 0
        }
        
        self.stepView.setStepIndex(index: index, enabledIndex: index)
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
