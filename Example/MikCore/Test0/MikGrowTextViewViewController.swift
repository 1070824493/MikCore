//
//  MikGrowTextViewViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

class MikGrowTextViewViewController: MikBaseViewController {
    
    private(set) lazy var textViewContainerView: MikGrowTextViewContainerView = {
        let aTextViewContainerView = MikGrowTextViewContainerView(config: {
            var aConfg = MikGrowTextViewContainerView.Config()
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
