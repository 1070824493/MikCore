//
//  Test0ViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/20.
//

import UIKit
import MikCore

class Test0ViewController: UITableViewController {

    enum TestType: String, CaseIterable {
        case MikButton, MikImageView, MikSwitch, MikNumberControl,
             MikToast, MikEmptyView, MikGrowTextView, MikDotProgressView,
             MikStarsView, MikPopoverView, MikAlertView, MikListContainerView,
             MikPaymentCardsOCR, MikCalendarView, MikPickerView, MikLockSlider,
             MikTextFieldFormatterView = "MikTextFieldFormatterView & MikFormatterTextField",
             MikPopupHoverViewController, APIsTest
    }
    
    private let testTypes: [TestType] = TestType.allCases
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    
    private func configure() {
        title = "Test 0"
    }
    
    private func setupSubviews() {}
    
    private func setupSubviewsConstraints() {}
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
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
        case .MikButton:
            self.navigationController?.pushViewController(MikButtonViewController(), animated: true)
        case .MikImageView:
            self.navigationController?.pushViewController(MikImageViewViewController(), animated: true)
        case .MikSwitch:
            self.navigationController?.pushViewController(MikSwitchViewController(), animated: true)
        case .MikNumberControl:
            self.navigationController?.pushViewController(MikNumberControlViewController(), animated: true)
        case .MikToast:
            self.navigationController?.pushViewController(MikToastViewController(), animated: true)
        case .MikEmptyView:
            self.navigationController?.pushViewController(MikEmptyViewController(), animated: true)
        case .MikGrowTextView:
            self.navigationController?.pushViewController(MikGrowTextViewViewController(), animated: true)
        case .MikDotProgressView:
            self.navigationController?.pushViewController(MikDotProgressViewViewController(), animated: true)
        case .MikStarsView:
            self.navigationController?.pushViewController(MikStarsViewViewController(), animated: true)
        case .MikPopoverView:
            self.navigationController?.pushViewController(MikPopoverViewViewController(), animated: true)
        case .MikAlertView:
            self.navigationController?.pushViewController(MikAlertViewViewController(), animated: true)
        case .MikListContainerView:
            self.navigationController?.pushViewController(MikListContainerViewController(), animated: true)
        case .MikPaymentCardsOCR:
            let vc = MikPaymentCardsOCRViewController()
            vc.confirmHandler = { (card) in
                print(card?.description ?? "")
            }
            vc.showInViewController(self)
        case .MikCalendarView:
            self.navigationController?.pushViewController(TestCalendarStyleViewController(), animated: true)
        case .MikPickerView:
            self.navigationController?.pushViewController(MikPickerTestViewController(), animated: true)
        case .MikLockSlider:
            self.navigationController?.pushViewController(MikLockSliderViewController(), animated: true)
        case .MikTextFieldFormatterView:
            self.navigationController?.pushViewController(MikTextFieldFormatterViewViewController(), animated: true)
        case .MikPopupHoverViewController:
            self.navigationController?.pushViewController(TestPopupHoverViewController(), animated: true)
        case .APIsTest:
            self.navigationController?.pushViewController(TestAPIsViewController(), animated: true)
        }
    }
    
}
