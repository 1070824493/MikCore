//
//  LKPickerTestViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit


fileprivate var randomFont: UIFont {
    let fonts: [UIFont] = [.systemFont(ofSize: 15), .boldSystemFont(ofSize: 18), .systemFont(ofSize: 25)]
    return fonts[Int(arc4random()) % fonts.count]
}
fileprivate var randomColor: UIColor {
    let colos: [UIColor] = [.black, .red, .purple]
    return colos[Int(arc4random()) % colos.count]
}

class LKPickerTestViewController: UITableViewController {

    private let titles: [String] = ["默认样式", "多分区、自定义样式"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(type(of: self))"
        clearsSelectionOnViewWillAppear = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idf = "reuseIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: idf)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: idf)
        }
        
        cell!.textLabel?.text = titles[indexPath.row]
        
        return cell!
    }
    
        
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
        switch indexPath.row {
        case 0:
            let items = Array(0...30).map({ LKPickerItem(title: "选项\($0)") })
            
            LKPickerViewController.pickerView(showIn: self, title: "这是标题这是标题这是标题", items: [items]) { (selectedIndexPaths) in
                var text = "选择了"
                selectedIndexPaths.forEach({ text += "第\($0.section)列, 第\($0.row)行" })
                print(text)
            }
        case 1:
            let items = Array(0...30).map({ LKPickerItem(title: "选项\($0)", font: randomFont, color: randomColor, isSelected: $0 == 10) })
            
            LKPickerViewController.pickerView(showIn: self, title: "这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题这是标题", items: [items, items, items], customConfirm: { (btn) in
                btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
                btn.setTitleColor(UIColor.purple, for: .normal)
            }) { (selectedIndexPaths) in
                var text = "选择了\n"
                selectedIndexPaths.forEach({ text += "第\($0.section)列、第\($0.row)行\n" })
                print(text)
            }
        default: ()
        }
    }

}
