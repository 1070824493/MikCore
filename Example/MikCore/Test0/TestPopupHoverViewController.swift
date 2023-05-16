//
//  TestPopupHoverViewController.swift
//  MikCore_Example
//
//  Created by m7 on 2022/3/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit
import MikCore

fileprivate extension MikPopupHoverStyle {
    
    var desc: String? {
        switch self {
        case .modal: return "show by modal"
        case .parent: return "move to parent"
        }
    }
    
}

class TestPopupHoverViewController: MikHoverParentController {
            
    // MikPopupHoverParentConfig
    func responderView(_ point: CGPoint) -> UIView? {
        return mTableView
    }
    
    var styles: [MikPopupHoverStyle] = [.modal, .parent]
    
    private var style: MikPopupHoverStyle?
    
    private lazy var mTableView: UITableView = {
        let aTabeleView = UITableView(frame: .zero, style: .plain)
        aTabeleView.dataSource = self
        aTabeleView.delegate = self
        aTabeleView.separatorStyle = .none
        aTabeleView.rowHeight = 56
        aTabeleView.tableFooterView = UIView()
        return aTabeleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }

}

// MARK: - Assistant
extension TestPopupHoverViewController {
    
    private func configure() {
        view.backgroundColor = UIColor.mik.general(.hexFFFFFF)
    }
    
    private func setupSubviews() {
        view.addSubview(mTableView)
    }
    
    private func setupSubviewsConstraints() {
        mTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension TestPopupHoverViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return styles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: UITableViewCell.self))
        }
        cell?.textLabel?.text = self.styles[indexPath.row].desc
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.style == nil, self.styles.indices ~= indexPath.row else { return }
        
        func showHoverViewController(style: MikPopupHoverStyle) {
            let testPopupHoverViewController = MikTestPopupHoverViewController()
            let popupHoverViewController = MikPopupHoverViewController(hoverViewController: testPopupHoverViewController)
            
            testPopupHoverViewController.closeHandler = { [weak popupHoverViewController, weak self] in
                popupHoverViewController?.hidden() {
                    self?.style = nil
                }
            }
            
            popupHoverViewController.show(in: self, style: style)
        }
        
        let style = self.styles[indexPath.row]
        
        self.style = style
        
        showHoverViewController(style: style)
    }
    
}

// MARK: - MikTestPopupHoverViewController
class MikTestPopupHoverViewController: MikHoverViewController {
    
    var hoverHeights: [CGFloat] { [400,
                                   UIViewController.mik.safeAreaMax.bottom + 60,
                                   UIScreen.mik.height - (UIViewController.mik.safeAreaMax.top + 10)] }
    
    
    var closeHandler: (() -> Void)?        
    
    private lazy var headerView: MikPopHeaderView = {
        let aView = MikPopHeaderView(title: "Title")
        aView.closeHandler = { [weak self] in
            self?.closeHandler?()
        }
        return aView
    }()
    
    private lazy var mTableView: UITableView = {
        let aTabeleView = UITableView(frame: .zero, style: .plain)
        aTabeleView.dataSource = self
        aTabeleView.delegate = self
        aTabeleView.separatorStyle = .none
        aTabeleView.rowHeight = 56
        aTabeleView.tableFooterView = UIView()
        return aTabeleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    deinit {
        print("*** \(String(describing: self)) deinit ***♻️")
    }

}

// MARK: - Assistant
extension MikTestPopupHoverViewController {
    
    private func configure() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(headerView)
        view.addSubview(mTableView)
    }
    
    private func setupSubviewsConstraints() {
        headerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        
        mTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0))
        }
    }
    
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension MikTestPopupHoverViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "reuseIdentifier")
        }
        cell?.textLabel?.text = "row：\(indexPath.row)"

        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(UIViewController(), animated: true)
    }
    
}
