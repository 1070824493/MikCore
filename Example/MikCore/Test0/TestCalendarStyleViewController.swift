//
//  TestCalendarStyleViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit

fileprivate extension MikCalendarStyle {
    
    var desc: String {
        switch self {
        case .single: return "SingleMonthView"
        case .singleForClass: return "ClassSingleMonthView"
        case .range: return "RangeMouthView"
        case .limit: return "LimitMouthView"
        }
    }
    
}

class TestCalendarStyleViewController: UITableViewController {

    private let styles: [MikCalendarStyle] = [.single(Date()),
                                              .singleForClass(Date()),
                                              .range((Calendar.current.date(byAdding: .day, value: -12, to: Date())!, Date())),
                                              .limit((Calendar.current.date(byAdding: .day, value: -12, to: Date())!, Date()), Date())]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.styles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: NSStringFromClass(UITableViewCell.self))
        }
        cell?.textLabel?.text = self.styles[indexPath.row].desc
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(MikCalendarViewController(style: self.styles[indexPath.row]), animated: true)
    }

}
