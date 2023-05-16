//
//  MikTabBarController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/20.
//

import UIKit

public class MikTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    private var lastSelectedIndex = 0
    private let roundView = UIView()
    
    private var titles = [String]()
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        UITabBar.appearance().barTintColor = .white
        self.delegate = self

        roundView.frame = CGRect.init(x: 0, y: self.tabBar.bounds.size.height/2+15, width: 6, height: 6)
        roundView.backgroundColor = UIColor.init(red: 207/255.0, green: 31/255.0, blue: 46/255.0, alpha: 1.0)
        roundView.layer.cornerRadius = 3.0
        self.tabBar.addSubview(roundView)
        
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lastController = self.viewControllers![self.lastSelectedIndex]
        lastController.tabBarItem.title = "•"
        
        self.changeRoundViewFrame(index: 0)
    }

    private func changeRoundViewFrame(index: Int) {
        let left: CGFloat = UIScreen.main.bounds.size.width / CGFloat(self.viewControllers!.count)
        var rect = self.roundView.frame
        rect.origin.x = left * CGFloat(index) + (left - 6) / 2
        self.roundView.frame = rect
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

        let lastController = tabBarController.viewControllers![self.lastSelectedIndex]
        lastController.tabBarItem.title = self.titles[self.lastSelectedIndex]

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            viewController.tabBarItem.title = "•"

            self.changeRoundViewFrame(index: tabBarController.selectedIndex)
        }
        self.lastSelectedIndex = tabBarController.selectedIndex
    }
}

extension MikTabBarController {
    
    public func addChildViewController(_ childVC: UIViewController, title: String, normalImage: UIImage?, selectedImage: UIImage?) {
        
        self.titles.append(title)
        
        let norImage = normalImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        let selImage = selectedImage?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

        childVC.tabBarItem.image = norImage
        childVC.tabBarItem.selectedImage = selImage
        childVC.tabBarItem.title = title
        childVC.tabBarItem.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.mik.general(.hex1B1B1B),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)
            ], for: .normal)
        childVC.tabBarItem.setTitleTextAttributes(
            [
                NSAttributedString.Key.foregroundColor: UIColor.mik.general(.hexCF1F2E),
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10)
            ], for: .selected)
        let nav = MikNavigationController(rootViewController: childVC)
        addChild(nav)
    }
}
