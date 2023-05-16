//
//  MikLockSliderViewController.swift
//  MikCore
//
//  Created by m7 on 2021/7/21.
//

import UIKit
import MikCore
class MikLockSliderViewController: UIViewController {

    private lazy var slider: MikLockSlider = {
        let aslider = MikLockSlider(title: "Slide to Pay")
        aslider.translatesAutoresizingMaskIntoConstraints = false
        aslider.frame = CGRect(x: 20, y: 200, width: UIScreen.main.bounds.width-40, height: 50)
        aslider.addTarget(self, action: #selector(self.next(_:)), for: .valueChanged)
        return aslider
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        view.addSubview(slider)
        
        slider.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.85)
            make.height.equalTo(50)
        }
        
    }
    
    @objc
    private func next(_ sender: Any) {
        MikPrint("MikLockSlider unlock success..")
    }

}
