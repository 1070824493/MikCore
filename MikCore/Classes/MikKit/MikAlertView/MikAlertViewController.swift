//
//  MikAlertViewController.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/4.
//

import UIKit
import SnapKit

open class MikAlertViewController: UIViewController {
    
    private let customView: UIView
    
    private lazy var backgroundView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        aView.isUserInteractionEnabled = false
        return aView
    }()
    
    private lazy var containerView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.white.withAlphaComponent(0)
        aView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        aView.alpha = 0
        return aView
    }()
    
    required public init(view: UIView) {
        self.customView = view
        
        super.init(nibName: nil, bundle: nil)
        
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .custom
        modalPresentationCapturesStatusBarAppearance = false
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    deinit {
        print("*** \(String(describing: self)) deinit ***♻️")
    }

}

// MARK: - Assistant
extension MikAlertViewController {
    
    private func setupSubviews() {
        containerView.addSubview(customView)
        
        view.addSubview(backgroundView)
        view.insertSubview(containerView, aboveSubview: backgroundView)
    }
    
    private func setupSubviewsConstraints() {
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        customView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}

// MAKR: - Public meds
public extension MikAlertViewController {
    
    static func alertView(_ view: UIView) -> MikAlertViewController {
        return MikAlertViewController(view: view)
    }
    
    func showInViewController(_ viewController: UIViewController, _ completion: ((Bool) -> Void)?) {
        viewController.present(self, animated: false) {
            UIView.transition(with: self.containerView, duration: 0.15, options: .curveEaseOut, animations: {
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.containerView.transform = CGAffineTransform.identity
                self.containerView.alpha = 1
            }, completion: completion)
        }
    }
    
    func hidden(_ completion:(() -> Void)?) {
        UIView.transition(with: self.containerView, duration: 0.1, options: .curveEaseIn, animations: {
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0)
            self.containerView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.containerView.alpha = 0
        }) { (_) in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
}
