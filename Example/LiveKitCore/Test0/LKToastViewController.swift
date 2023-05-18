//
//  LKToastViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/21.
//

import UIKit

class LKToastViewController: UITableViewController {

    enum ToastStyle: String, CaseIterable {
        case activityHUD = "Activity HUD", logoHUD = "Logo HUD", messageHUD = "Message HUD", hideHUD = "Hide HUD", infomation = "Infomation title & message toast", infomationTitle = "Infomation only titlle toast", success = "Success toast", warn = "Warn toast", error = "error toast"
    }
    
    private var toastTypes: [ToastStyle] = ToastStyle.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(type(of: self))"
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.lk.width, height: UIViewController.lk.safeAreaMax.top)))

        navigationItem.titleView = {
            let aTF = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 44))
            aTF.layer.cornerRadius = 4
            aTF.layer.masksToBounds = true
            aTF.layer.borderWidth = 1
            aTF.layer.borderColor = UIColor.lightGray.cgColor
            return aTF
        }()
        
        tableView.keyboardDismissMode = .onDrag
        
        // Do any additional setup after loading the view.
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

extension LKToastViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.toastTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: UITableViewCell.self)))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: type(of: UITableViewCell.self)))
        }
        cell?.textLabel?.text = self.toastTypes[indexPath.row].rawValue
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.toastTypes[indexPath.row] {
        case .activityHUD: LKToast.showHUD(in: self.view)
        case .logoHUD: LKToast.showHUD(style: .logo, in: self.view)
        case .messageHUD: LKToast.showHUD(style: .message(ToastStyle.allCases.randomElement()?.rawValue), in: self.view)
        case .hideHUD: LKToast.hideHUD(in: self.view)
        case .infomation: LKToast.showToast(style: .information(title: "Type notification here Type n o t i fi ca ti on he re Typ e no tifi cation here", message: "Something can go here more Something can go here more Something can go here more"), action: LKToast.LKToastAction(title: "Undo", actionHandler: {
            print("undo...")
        }))
        case .infomationTitle: LKToast.showToast(style: .information(title: "Type notification here Type Type notification here Type Type notification here Type", message: nil), action: LKToast.LKToastAction(title: "Undo", actionHandler: {
            print("undo...")
        }))
        case .success: LKToast.showToast(in: self.view, style: .success(title: "Type notification", message: nil), action: LKToast.LKToastAction(title: "Undo", actionHandler: {
            print("undo...")
        }))
        case .warn: LKToast.showToast(style: .warn(title: "Type notification here Type Type notification here Type Type notification here Type", message: nil), action: LKToast.LKToastAction(title: "Undo", actionHandler: {
            print("undo...")
        }))
        case .error:
            LKToast.showToast(style: .error(title: "Type notification here Type Type notification here Type Type notification here Type", message: nil), action: nil)
        }
    }
    
}
