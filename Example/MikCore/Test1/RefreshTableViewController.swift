//
//  RefreshTableViewController.swift
//  MikCore
//
//  Created by gaowei on 2021/4/29.
//

import UIKit

class RefreshTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataCount = 10
    
    let tableView = UITableView.init(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50.rate
        self.view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(-UIViewController.mik.safeAreaMax.bottom - 20)
            make.left.right.equalToSuperview()
        }
        tableView.backgroundColor = UIColor.systemGroupedBackground
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.mik.width, height: 20.rate))
        self.tableView.tableHeaderView = headerView
        self.tableView.tableFooterView = UIView()

        
        self.tableView.addHeaderPullRefresh { [weak self] in
            self?.dataCount = 10
            self?.tableView.stopPullToRefresh(hasMoreData: true)
            self?.tableView.reloadData()
        }
        self.tableView.addFooterPullRefresh { [weak self] in
            guard let `self` = self else { return }
            self.dataCount += 10
            self.tableView.stopPullToRefresh(hasMoreData: self.dataCount < 50 )
            self.tableView.reloadData()
        }
//        self.tableView.startPullToRefresh()

    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.dataCount
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: String(describing: type(of: UITableViewCell.self)))
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: String(describing: type(of: UITableViewCell.self)))
        }
          
        cell?.textLabel?.text = "\(indexPath.row)"

        return cell!
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
