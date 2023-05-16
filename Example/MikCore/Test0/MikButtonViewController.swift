//
//  MikButtonViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
import SnapKit

fileprivate extension MikButton.Style {
    
    var title: String? {
        switch self {
        case .fillRed: return "fill with red color"
        case .fillBlack: return "fill with black color"
        case .borderRed: return "red"
        case .borderBlack: return "border with black"
        default: return "Coustom button"
        }
    }
    
}

class MikButtonViewController: UIViewController {

    private lazy var buttonStyles: [MikButton.Style] = [.fillRed, .fillBlack, .borderRed, .borderBlack, custom0Style, custom1Style, custom2Style, custom3Style]
    
    private lazy var custom0Style: MikButton.Style = {
        var config = MikCustomButtonConfig()
        config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
        config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        config.titleFont = UIFont.mik.font(.nunitoSans, size: 12)
        config.titleColor = UIColor.mik.general(.hex757575)
        config.highlightTitleColor = UIColor.mik.general(.hex757575)
        config.disabledTitleColor = UIColor.mik.general(.hex757575)
        config.borderColor = UIColor.mik.general(.hexF6F6F6)
        
        return .custom(config: config)
    }()
    
    private lazy var custom1Style: MikButton.Style = {
        var config = MikCustomButtonConfig()
        config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
        config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        config.titleFont = UIFont.mik.font(.nunitoSans, size: 12)
        config.titleColor = UIColor.mik.general(.hexF6F6F6)
        config.highlightTitleColor = UIColor.mik.general(.hexF6F6F6)
        config.disabledTitleColor = UIColor.mik.general(.hexF6F6F6)
        config.borderColor = UIColor.mik.general(.hexECF6F4)
        
        return .custom(config: config)
    }()
    
    private lazy var custom2Style: MikButton.Style = {
        var config = MikCustomButtonConfig()
        config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexFFFFFF))
        config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hex1B1B1B, alpha: 0.07))
        config.titleFont = UIFont.mik.font(.nunitoSans, size: 12)
        config.titleColor = UIColor.mik.general(.hex0475BC)
        config.highlightTitleColor = UIColor.mik.general(.hex0475BC)
        config.disabledTitleColor = UIColor.mik.general(.hex0475BC)
        config.borderColor = UIColor.mik.general(.hex0475BC)
        
        return .custom(config: config)
    }()
    
    private lazy var custom3Style: MikButton.Style = {
        var config = MikCustomButtonConfig()
        config.backgroundImage = UIImage.mik.image(UIColor.mik.general(.hexF8F3EC))
        config.highlightBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexF8F3EC, alpha: 0.07))
        config.disabledBackgroundImage = UIImage.mik.image(UIColor.mik.general(.hexF8F3EC, alpha: 0.07))
        config.titleFont = UIFont.mik.font(.nunitoSans, size: 12)
        config.titleColor = UIColor.mik.general(.hexA85D00)
        config.highlightTitleColor = UIColor.mik.general(.hexA85D00)
        config.disabledTitleColor = UIColor.mik.general(.hexA85D00)
        config.borderColor = UIColor.mik.general(.hexA85D00)
        
        return .custom(config: config)
    }()
    
    private lazy var buttons: [UIView] = self.buttonStyles.enumerated().map({
        let aBtn = MikButton(style: $1)
        aBtn.setTitle($1.title, for: .normal)
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14)
        aBtn.setCorner(radius: 20)
        return aBtn
    })
    
    private lazy var topImageButton: MikButton = {
        let aBtn = MikButton()
        aBtn.setBackgroundImageWithColor(UIColor.mik.general(.hex1B1B1B), state: .normal)
        aBtn.setBackgroundImageWithColor(UIColor.mik.general(.hex5F5F5F), state: .highlighted)
        aBtn.setTitleColor(UIColor.mik.text(.hexFFFFFF), for: .normal)
        aBtn.setCorner(radius: 20)
        aBtn.setTitle("Check out with", for: .normal)
        aBtn.setImage(UIImage(named: "tabbar_dash_s"), for: .normal)        
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14)
        aBtn.mik.setImageDirection(.top, space: 10)
        return aBtn
    }()
    
    private lazy var leftImageButton: MikButton = {
        let aBtn = MikButton(style: .fillBlack)
        aBtn.setCorner(radius: 20)
        aBtn.setTitle("Check out with", for: .normal)
        aBtn.setImage(UIImage(named: "tabbar_dash_s"), for: .normal)
        aBtn.mik.setImageDirection(.left, space: 10)
        return aBtn
    }()
    
    private lazy var bottomImageButton: MikButton = {
        let aBtn = MikButton()
        aBtn.setBackgroundImageWithColor(UIColor.mik.general(.hex757575), state: .normal)
        aBtn.setBackgroundImageWithColor(UIColor.mik.general(.hex5F5F5F), state: .highlighted)
        aBtn.setTitleColor(UIColor.mik.text(.hex1B1B1B), for: .normal)
        aBtn.setCorner(radius: 20)
        aBtn.setTitle("Checkout", for: .normal)
        aBtn.setImage(UIImage(named: "tabbar_dash_s"), for: .normal)
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 30)
        aBtn.mik.setImageDirection(.bottom, space: 10)
        return aBtn
    }()
    
    private lazy var rightImageButton: MikButton = {
        let aBtn = MikButton(style: .borderRed)
        aBtn.setCorner(radius: 20)
        aBtn.setTitle("Checkout", for: .normal)
        aBtn.setImage(UIImage(named: "tabbar_dash_s"), for: .normal)
        aBtn.mik.setImageDirection(.right, space: 10)
        return aBtn
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: buttons + [topImageButton, leftImageButton, bottomImageButton, rightImageButton])
        aStackView.axis = .vertical
        aStackView.alignment = .center
        aStackView.spacing = 20
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    override func loadView() {
        view = MikScrollView(axis: .vertical)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didClick(_:))))

        // Do any additional setup after loading the view.
        
        (view as? MikScrollView)?.setupSubViews([mStackView])
        
        mStackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(UIViewController.mik.safeAreaMax.top)
            make.centerX.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(250)
        }
    }
    
    
    @objc
    private func didClick(_ sender: UIButton) {
        buttons.forEach({
            let aBtn = $0 as? UIButton
            aBtn?.isEnabled = !(aBtn?.isEnabled ?? false)
        })
    }

}
