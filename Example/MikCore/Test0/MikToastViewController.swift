//
//  MikToastViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/21.
//

import UIKit


fileprivate extension MikToast.MikHUDStyle {

    var next: MikToast.MikHUDStyle? {
        switch self {
        case .activity: return .logo
        case .logo: return .message("加载中....")
        case .message(_): return nil
        }
    }
    
}

fileprivate extension MikToast.MikToastStyle {
    
    var next: MikToast.MikToastStyle {
        switch self {
        case .information(let title, let message): return .success(title: title, message: message)
        case .success(let title, let message): return .warn(title: title, message: message)
        case .warn(let title, let message): return .error(title: title, message: message)
        case .error(let title, let message): return .information(title: title, message: message)
        }
    }
    
}

class MikToastViewController: UITableViewController {

    enum ToastStyle: String, CaseIterable {
        case HUD = "HUD（点击显示其它样式）", toast = "Toast（点击显示其它样式）"
    }
    
    private var hudStyle: MikToast.MikHUDStyle? = .activity
    
    private var toastTypes: [ToastStyle] = ToastStyle.allCases
    
    private var toastStyle: MikToast.MikToastStyle = .information(title: "This is tost title, this is tost title This is tost title, this is tost title This is tost title, this is tost title",
                                                                  message: "This is tost message, this is tost message this is tost message this is tost message this is tost message this is tost message this is tost message this is tost message")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInsetAdjustmentBehavior = .never
        self.tableView.tableHeaderView = UIView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.mik.width, height: UIViewController.mik.safeAreaMax.top)))

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

}

extension MikToastViewController {
    
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
            
        case .HUD:
            if let style = self.hudStyle {
                self.hudStyle = self.hudStyle?.next
                MikToast.showHUD(style: style, in: self.view, isInteraction: false)
            }else {
                self.hudStyle = .activity
                MikToast.hideHUD(in: self.view)
            }
            
        case .toast:
            defer { self.toastStyle = self.toastStyle.next }
            MikToast.showToast(style: self.toastStyle, action: MikToast.MikToastAction(title: "Action", actionHandler: {
                print("Action...")
            }))
        }
    }
    
}
