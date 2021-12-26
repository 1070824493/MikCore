//
//  MikImageViewViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit

class MikImageViewViewController: MikBaseViewController {    
    
    private let imageViewSizes: [CGSize] = (0 ..< 7).map({ _ in CGSize(width: CGFloat.random(in: 50 ..< 200), height: CGFloat.random(in: 10 ..< 200)) })
    
    private lazy var imgViews: [MikImageView] = imageViewSizes.map({ _ in
        let aImageView = MikImageView()
        aImageView.isUserInteractionEnabled = true
        return aImageView
    })
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: imgViews)
        aStackView.axis = .vertical
        aStackView.alignment = .center
        aStackView.spacing = 20
        aStackView.distribution = .fillProportionally
        return aStackView
    }()

    override func loadView() {
        view = MikScrollView(axis: .vertical)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        (view as? MikScrollView)?.setupSubViews([mStackView])
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(UIViewController.mik.safeAreaMax.top)
            make.bottom.lessThanOrEqualToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        imgViews.enumerated().forEach({ (idx, view) in
            view.snp.makeConstraints { (make) in
                make.size.equalTo(imageViewSizes[idx])
            }
        })
    }

}
