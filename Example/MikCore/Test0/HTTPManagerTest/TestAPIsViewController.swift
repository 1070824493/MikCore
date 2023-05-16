//
//  TestAPIsViewController.swift
//  MikCore_Example
//
//  Created by m7 on 2022/4/28.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class TestAPIsViewController: UITableViewController {
    
    enum APIsType: String, CaseIterable {
        case mik, pubtool, usr, fin, mohRSC, cpm, wish, sch, fgm, qa, other
    }
    
    private let types: [APIsType] = APIsType.allCases

    override func viewDidLoad() {
        super.viewDidLoad()

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


// MARK: - UITableViewDelegate, UITableViewDataSource
extension TestAPIsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.types.count
    }
        
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: UITableViewCell.self))
        }
        cell?.textLabel?.text = self.types.mik[safe: indexPath.row]?.rawValue
        return cell ?? UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.types.indices ~= indexPath.row else { return }
        
        let type = self.types[indexPath.row]
        
        switch type {
        case .mik:
            self.navigationController?.pushViewController(TestMIKAPIViewController(), animated: true)
        case .wish:
            self.navigationController?.pushViewController(TestWishlistsRequestViewController(), animated: true)
        case .cpm:
            self.navigationController?.pushViewController(TestCPMRequestViewController(), animated: true)
        case .sch:
            self.navigationController?.pushViewController(TestSchHTTPManagerViewController(), animated: true)
        case .qa:
            self.navigationController?.pushViewController(TestQAAPIViewController(), animated: true)
        case .other:
            self.navigationController?.pushViewController(TestHTTPManagerViewController(), animated: true)
        default: return
        }
    }
    
}
