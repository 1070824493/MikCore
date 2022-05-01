//
//  UIScrollerView.swift
//  SellerMobile
//
//  Created by yu12 on 2021/3/12.
//

import UIKit
import MJRefresh


public extension UIScrollView {

    // MARK: - Add & Remove
    /// 统一通过此接口添加PullRefresh的Header，以便以后的刷新样式修改
    func addHeaderPullRefresh(handler: @escaping (() -> ())) {
        let header = MJRefreshNormalHeader(refreshingBlock: handler)
        header.lastUpdatedTimeLabel?.isHidden = true
        mj_header = header
    }
    
    func removeRefreshHeader() {
        mj_header = nil
    }
    
    /// 统一通过此接口添加PullRefresh的Footer，以便以后的刷新样式修改
    func addFooterPullRefresh(handler: @escaping (() -> ())) {
        mj_footer = MJRefreshAutoNormalFooter(refreshingBlock: handler).autoChangeTransparency(true)
    }
    
    func removeRefreshFooter() {
        mj_footer = nil
    }
    
    // MARK: - Start & Stop
    func startPullToRefresh(){
        self.mj_header?.beginRefreshing()
    }
    
    /// 停止 下拉刷新 / 上拉加载更多
    /// - Parameter requestFailure: 默认请求成功；请求失败，hasMoreData参数无效
    /// - Parameter hasMoreData: 是否需要加载更多数据
    func stopPullToRefresh(requestFailure: Bool = false, hasMoreData: Bool = false) {
        if mj_header?.isRefreshing == true{
            mj_header?.endRefreshing()
        }

        if hasMoreData || requestFailure{
            mj_footer?.endRefreshing()
        }else{
            mj_footer?.endRefreshingWithNoMoreData()
        }

    }
    
    // MARK: - State
    func resetNoMoreData() {
        self.mj_footer?.resetNoMoreData()
    }
    
    func isPullRefreshing() -> Bool {
        if self.mj_header?.isRefreshing ?? false || self.mj_footer?.isRefreshing ?? false {
            return true
        }
        return false
    }
}
