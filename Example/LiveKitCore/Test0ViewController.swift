//
//  Test0ViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
@_exported import LKCore

class Test0ViewController: UITableViewController {
    
    enum TestType: String, CaseIterable {
        
        case LKImageView = "LKImageView"
        case LKSwitch = "LKSwitch"
        case LKNumberControl = "LKNumberControl"
        case LKToast = "LKToast"
        case LKGrowTextView = "LKGrowTextView"
        case LKDotProgressView = "LKDotProgressView"
        case MinStarsView = "LKStarsView"
        case LKPopoverView = "LKPopoverView"
        case LKAlertView = "LKAlertView"
        case LKListContainerView = "LKListContainerView"
        case LKPickerView = "LKPickerView"
        case LKTextFieldFormatterView = "LKTextField & LKTextFieldFormatterView"
    }
    
    private let testTypes: [TestType] = TestType.allCases
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        var colors: [UIColor] = LKNameSpace.HexColorsEnum.allCases.map({ UIColor.lk.general($0) })
        
        LKNameSpace.HexColorsEnum.allCases.forEach({
            self.view.backgroundColor = UIColor.lk.general($0)
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
            
        case .LKImageView:
            self.navigationController?.pushViewController(LKImageViewViewController(), animated: true)
        case .LKSwitch:
            self.navigationController?.pushViewController(LKSwitchViewController(), animated: true)
        case .LKNumberControl:
            self.navigationController?.pushViewController(LKNumberControlViewController(), animated: true)
        case .LKToast:
            self.navigationController?.pushViewController(LKToastViewController(), animated: true)
        case .LKGrowTextView:
            self.navigationController?.pushViewController(LKGrowTextViewViewController(), animated: true)
        case .LKDotProgressView:
            self.navigationController?.pushViewController(LKDotProgressViewViewController(), animated: true)
        case .MinStarsView:
            self.navigationController?.pushViewController(LKStarsViewViewController(), animated: true)
        case .LKPopoverView:
            self.navigationController?.pushViewController(LKPopoverViewViewController(), animated: true)
        case .LKAlertView:
            self.navigationController?.pushViewController(LKAlertViewViewController(), animated: true)
        case .LKListContainerView:
            self.navigationController?.pushViewController(LKListContainerViewController(), animated: true)
            
        case .LKPickerView:
            self.navigationController?.pushViewController(LKPickerTestViewController(), animated: true)
        case .LKTextFieldFormatterView:
            self.navigationController?.pushViewController(LKTextFieldFormatterViewViewController(), animated: true)
        }
    }
    
}
