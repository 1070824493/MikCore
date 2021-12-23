//
//  UIScrollerView.swift
//  SellerMobile
//
//  Created by yu12 on 2021/3/12.
//

import UIKit
import ESPullToRefresh

public extension UIScrollView {
    
    // MARK: - Add & Remove
    
    /// 统一通过此接口添加PullRefresh的Header，以便以后的刷新样式修改
    func addHeaderPullRefresh(handler: @escaping (() -> ())) {
        self.es.removeRefreshHeader()
        
        let headerAnimator = MikRefreshHeaderAnimator.init(frame: CGRect.zero)
        self.es.addPullToRefresh(animator: headerAnimator, handler: handler)
    }
    
    func removeRefreshHeader() {
        self.es.removeRefreshHeader()
    }
    
    /// 统一通过此接口添加PullRefresh的Footer，以便以后的刷新样式修改
    func addFooterPullRefresh(handler: @escaping (() -> ())) {
        self.es.removeRefreshFooter()
        
        let footerAnimator = MikRefreshFooterAnimator.init(frame: CGRect.zero)
        self.es.addInfiniteScrolling(animator: footerAnimator, handler: handler)
        self.es.base.footer?.isHidden = true
    }
    
    func removeRefreshFooter() {
        self.es.removeRefreshFooter()
    }
    
    // MARK: - Start & Stop
    func startPullToRefresh(){
        self.es.startPullToRefresh()
    }
    
    /// 停止 下拉刷新 / 上拉加载更多
    /// - Parameter requestFailure: 默认请求成功；请求失败，hasMoreData参数无效
    /// - Parameter hasMoreData: 是否需要加载更多数据
    func stopPullToRefresh(requestFailure: Bool = false, hasMoreData: Bool = false) {
        if let header = self.es.base.header, header.isRefreshing {
            header.stopRefreshing()
        }
        
        guard let footer = self.es.base.footer else { return }
        if footer.isRefreshing {
            footer.stopRefreshing()
        } else {
            footer.isHidden = !hasMoreData
        }
        
        if requestFailure { return }
        
        footer.noMoreData = !hasMoreData
    }
    
    // MARK: - State
    func resetNoMoreData() {
        self.es.resetNoMoreData()
    }
    
    func isPullRefreshing() -> Bool {
        if self.es.base.header?.isRefreshing ?? false || self.es.base.footer?.isRefreshing ?? false {
            return true
        }
        return false
    }
}
