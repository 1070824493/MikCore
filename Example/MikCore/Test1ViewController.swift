//
//  Test1ViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit

class Test1ViewController: UITableViewController {

    private let pushNames: [String] = [ "StepView",
                                        "StarView",
                                        "TextView",
                                        "MikFilterView",
                                        "DropBoxView",
                                        "BottomButtonView",
                                        "BottomPop",
                                        "GuideView",
                                        "RefreshTableView",
                                        "MikOmitTextView"
    ]
                        
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
        
        setupSubviews()
    }
    
    
    
    required init() {
        super.init(style: .plain)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Test1"
    }
    
    override init(style: UITableView.Style) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension Test1ViewController {
    
    private func setupSubviews() {
        tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: UITableViewCell.self)))
    }
    
}

extension Test1ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pushNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: UITableViewCell.self)))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: type(of: UITableViewCell.self)))
        }
        if indexPath.row < 5 {
            cell?.textLabel?.font = UIFont.mik.font(.InterBold, size: 14.rate)
        } else {
            cell?.textLabel?.font = UIFont.mik.font(.InterExtraBold, size: 14.rate)
        }
        cell?.textLabel?.text = self.pushNames[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workName = Bundle.main.infoDictionary?["CFBundleExecutable"] as! String
        let pushName = self.pushNames[indexPath.row] + "Controller"
        let vcClass = NSClassFromString("\(workName).\(pushName)") as! UIViewController.Type
        let controller = vcClass.init()
        controller.title = self.pushNames[indexPath.row]
        controller.view.backgroundColor = .white
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
