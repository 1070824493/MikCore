//
//  MikStarsViewViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class MikStarsViewViewController: MikBaseViewController {

    // 默认样式
    private lazy var starView: MikStarsView = MikStarsView()
    
    // 自定义样式
    private lazy var star1View: MikStarsView = MikStarsView(config: {
        var config = MikStarsView.Config()
        config.maximumImage = UIImage(named: "mik_scorestar")
        config.minimumImage = UIImage(named: "mik_scorestarfill")
        config.maximumTincolor = UIColor.mik.general(.hexCDCDCD)
        config.minimumTincolor = UIColor.mik.general(.hexCF1F2E)
        config.starHeight = 20
        config.space = 30
        config.repeatCount = 3
        config.isEditEnable = true
        return config
    }())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(starView)
        view.addSubview(star1View)
        
        starView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        star1View.snp.makeConstraints { (make) in
            make.top.equalTo(starView.snp.bottom).offset(20)
            make.centerX.equalTo(starView)
        }
        
        _ = star1View.rx.star.take(until: rx.deallocated).asObservable().subscribe(onNext: { (value) in
            print("click star1 value: \(value)")
        })
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        starView.star = Float.random(in: 0 ..< 5)        
        star1View.star = Float.random(in: 0 ..< 3)
        print("random star: \(starView.star), \(star1View.star)....")
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
