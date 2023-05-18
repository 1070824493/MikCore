//
//  LKDotProgressViewViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

class LKDotProgressViewViewController: LKBaseViewController {

    private let titles = ["Processed\nNov 8 ProcessedProcessedProcessed", "Processed\nNov 8", "Processed\nNov 8", "Processed\nNov 8ProcessedProcessedProcessed"]
    
    private lazy var dotProgressView: LKDotProgressView = LKDotProgressView(titles: titles)
//    private lazy var dotProgressView: LKDotProgressView = LKDotProgressView(totalStep: titles.count)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        // Do any additional setup after loading the view.
        
        view.addSubview(dotProgressView)
        
        dotProgressView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dotProgressView.titles = titles
        dotProgressView.step = 2
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.dotProgressView.step = Int.random(in: 0 ..< titles.count)
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
