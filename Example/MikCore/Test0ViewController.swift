//
//  Test0ViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
@_exported import MikCore

class Test0ViewController: UITableViewController {
    
    enum TestType: String, CaseIterable {
        
        case MikImageView = "MikImageView"
        case MikSwitch = "MikSwitch"
        case MikNumberControl = "MikNumberControl"
        case MikToast = "MikToast"
        case MikGrowTextView = "MikGrowTextView"
        case MikDotProgressView = "MikDotProgressView"
        case MinStarsView = "MikStarsView"
        case MikPopoverView = "MikPopoverView"
        case MikAlertView = "MikAlertView"
        case MikListContainerView = "MikListContainerView"
        case MikCalendarView = "MikCalendarView"
        case MikPickerView = "MikPickerView"
        case MikTextFieldFormatterView = "MikTextField & MikTextFieldFormatterView"
    }
    
    private let testTypes: [TestType] = TestType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        var colors: [UIColor] = MikNameSpace.HexColorsEnum.allCases.map({ UIColor.mik.general($0) })
        
        MikNameSpace.HexColorsEnum.allCases.forEach({
            self.view.backgroundColor = UIColor.mik.general($0)
        })
    }
    
    
    required init() {
        super.init(style: .plain)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        title = "Test0"
    }
    
    override init(style: UITableView.Style) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension Test0ViewController {
    
    private func setupSubviews() {
        tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: UITableViewCell.self)))
    }
    
}

extension Test0ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testTypes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: UITableViewCell.self)))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: type(of: UITableViewCell.self)))
        }
        cell?.textLabel?.text = self.testTypes[indexPath.row].rawValue
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.testTypes[indexPath.row] {
            
        case .MikImageView:
            self.navigationController?.pushViewController(MikImageViewViewController(), animated: true)
        case .MikSwitch:
            self.navigationController?.pushViewController(MikSwitchViewController(), animated: true)
        case .MikNumberControl:
            self.navigationController?.pushViewController(MikNumberControlViewController(), animated: true)
        case .MikToast:
            self.navigationController?.pushViewController(MikToastViewController(), animated: true)
        case .MikGrowTextView:
            self.navigationController?.pushViewController(MikGrowTextViewViewController(), animated: true)
        case .MikDotProgressView:
            self.navigationController?.pushViewController(MikDotProgressViewViewController(), animated: true)
        case .MinStarsView:
            self.navigationController?.pushViewController(MikStarsViewViewController(), animated: true)
        case .MikPopoverView:
            self.navigationController?.pushViewController(MikPopoverViewViewController(), animated: true)
        case .MikAlertView:
            self.navigationController?.pushViewController(MikAlertViewViewController(), animated: true)
        case .MikListContainerView:
            self.navigationController?.pushViewController(MikListContainerViewController(), animated: true)
            
        case .MikCalendarView:
            self.navigationController?.pushViewController(TestCalendarStyleViewController(), animated: true)
        case .MikPickerView:
            self.navigationController?.pushViewController(MikPickerTestViewController(), animated: true)
        case .MikTextFieldFormatterView:
            self.navigationController?.pushViewController(MikTextFieldFormatterViewViewController(), animated: true)
        }
    }
    
}
