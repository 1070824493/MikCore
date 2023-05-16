//
//  GuideViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/27.
//

import UIKit

class GuideViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let itemView = UIView()
        itemView.backgroundColor = .blue
        self.view.addSubview(itemView)
        itemView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(40.rate)
            make.height.equalTo(100.rate)
            make.centerY.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            let itemTitle = [ NSAttributedString.Key.foregroundColor : UIColor.mik.text(.hex0475BC), NSAttributedString.Key.font : UIFont.mik.font(.nunitoSansBold, size: 16.rate) ]
            let title = NSAttributedString.init(string: "My Rewards Card", attributes: itemTitle)
            let itemContent = [ NSAttributedString.Key.foregroundColor : UIColor.mik.text(.hex1B1B1B), NSAttributedString.Key.font : UIFont.mik.font(size: 14.rate) ]
            let content = NSMutableAttributedString.init(string: "Swipe up for the rewards barcode that you'll need to scan to track your in-store purchases. Rewards are automatically earned on online purchases.", attributes: itemContent)
            content.addAttributes([ NSAttributedString.Key.foregroundColor : UIColor.red ], range: NSRange.init(location: 0, length: 8))
            MikGuideView.show(fromView: itemView, cornerType: .allCorners, cornerRadius: 0, title: title, content: content)
        }
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
