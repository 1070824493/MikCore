//
//  TableView+AutoLayout.swift
//  SellerMobile
//
//  Created by gaowei on 2021/3/5.
//

import UIKit

public extension UITableView {
    
    func sizeHeaderToFit() {
        guard let headerView = self.tableHeaderView else {
            return
        }
        
//        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        
        let height = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var headerFrame = headerView.frame
        headerFrame.size.height = height
        headerView.frame = headerFrame
        
        self.tableHeaderView = headerView
    }
    
    func sizeFooterToFit() {
        guard let footerView = self.tableFooterView else {
            return
        }
        
//        footerView.setNeedsLayout()
        footerView.layoutIfNeeded()
        
        let height = footerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        var footerFrame = footerView.frame
        footerFrame.size.height = height
        footerView.frame = footerFrame
        
        self.tableFooterView = footerView
    }
    
}
