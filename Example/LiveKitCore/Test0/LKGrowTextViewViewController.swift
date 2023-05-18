//
//  LKGrowTextViewViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

class LKGrowTextViewViewController: LKBaseViewController {
    
    private(set) lazy var textViewContainerView: LKGrowTextViewContainerView = {
        let aTextViewContainerView = LKGrowTextViewContainerView(config: {
            var aConfg = LKGrowTextViewContainerView.Config()
            aConfg.maxTextLine = 6
            aConfg.minHeight = 44
            return aConfg
        }())
                
        aTextViewContainerView.textView.textContainerInset = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        aTextViewContainerView.textView.placeholder = "Write a message"
        aTextViewContainerView.textView.heightChangedBlock = { [weak self] in
            UIView.animate(withDuration: 0.25) { self?.view.layoutIfNeeded() }
        }
        return aTextViewContainerView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray

        view.addSubview(textViewContainerView)
        
        textViewContainerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }

}
