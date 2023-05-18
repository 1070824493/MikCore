//
//  LKDragTableView.swift
//  LKMobile
//
//  Created by gaowei on 2021/3/1.
//

import UIKit

enum AutoScroll {
    case kAutoScrollUp
    case kAutoScrollDown
}


public protocol LKDragTableProtocol: NSObjectProtocol {
    
    /// 拖拽位置切换
    /// - Parameters:
    ///   - fromIndexPath: 从某位置
    ///   - toIndexPath: 切换到某位置
    func dragToExchange(_ tableView: LKDragTableView, fromIndexPath: IndexPath, toIndexPath: IndexPath) -> Void
}

public class LKDragTableView: UITableView {
    
    /// 拖拽代理
    public weak var dragProtocol: LKDragTableProtocol?
    
    /// 设置无法拖动的组，[section]
    public var isCannotDragGroup: [Int]?
    
    /**
     *  当cell拖拽到tableView边缘时,tableView的滚动速度
     *  每个时间单位滚动多少距离，默认为3
     */
    public var scrollSpeed: CGFloat = 3.0
    
    private var cellImageView: UIImageView?
    private var displayLink: CADisplayLink?
    private var autoScroll: AutoScroll?
    
    private var originalIndexPath: IndexPath?
    private var fromIndexPath: IndexPath?
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        // 使用长按排序功能，必须使用rowHeight设置高度
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
        
        self.addGestureRecognizer(UILongPressGestureRecognizer.init(target: self, action: #selector(moveRow(longPress:))))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - private func
extension LKDragTableView {
    
    @objc private func moveRow(longPress: UILongPressGestureRecognizer) {
        let point = longPress.location(in: self) // 获取点击的位置
        
        if longPress.state == .began {
            let indexPath = self.indexPathForRow(at: point)
            if indexPath == nil {
                return
            }
            if self.isCannotDragGroup?.count ?? 0 > 0 {
                /// 包含不可拖拽的组
                if self.isCannotDragGroup!.contains(indexPath!.section) {
                    return
                }
            }
            
            self.originalIndexPath = indexPath!
            self.fromIndexPath = indexPath!
            
            let cell: UITableViewCell = self.cellForRow(at: self.fromIndexPath!)!
            self.cellImageView = self.createCellImageView(cell: cell)
            
            // 更改imageView的中心点为手指点击位置
            var center = cell.center
            self.cellImageView?.center = center
            
            UIView.animate(withDuration: 0.1) {
                center.y = point.y
                self.cellImageView?.center = center
                self.cellImageView?.transform = .init(scaleX: 1.05, y: 1.05)
                self.cellImageView?.alpha = 0.9
            } completion: { (finished) in
                cell.isHidden = true
            }
        } else if longPress.state == .changed {
            let toIndexPath = self.indexPathForRow(at: point)
            if toIndexPath == nil || self.fromIndexPath == nil {
                return
            }
            
            var center = self.cellImageView?.center
            center?.y = point.y
            self.cellImageView?.center = center!
            
            // 判断cell是否被拖拽到了tableView的边缘，如果是，则自动滚动tableView
            if self.isScrollToEdge() {
                self.startTimerToScrollTableView()
            } else {
                self.displayLink?.invalidate()
            }
            
            /*
             若当前手指所在indexPath不是要移动cell的indexPath，
             且是插入模式，则执行cell的插入操作
             每次移动手指都要执行该判断，实时插入
            */
            if toIndexPath != self.fromIndexPath {
                self.moveCell(toIndexPath: toIndexPath!)
            }
        } else {
            if self.fromIndexPath == nil {
                return
            }
            
            self.displayLink?.invalidate()

            // 将隐藏的cell显示出来，并将imageView移除掉
            let cell: UITableViewCell = self.cellForRow(at: self.fromIndexPath!)!
            UIView.animate(withDuration: 0.25) {
                self.cellImageView?.center = cell.center
                self.cellImageView?.transform = .identity
            } completion: { (finished) in
                cell.isHidden = false
                
                self.cellImageView?.removeFromSuperview()
                self.cellImageView = nil
                
                self.dragProtocol?.dragToExchange(self, fromIndexPath: self.originalIndexPath!, toIndexPath: self.fromIndexPath!)
                self.fromIndexPath = nil
            }
        }
    }
    
    /// 判断拖动视图是否在顶部或底部
    private func isScrollToEdge() -> Bool {

        // imageView拖动到tableView顶部，且tableView没有滚动到最上面
        if (self.cellImageView!.frame.minY < (self.contentOffset.y + self.contentInset.top) && (self.contentOffset.y > -self.contentInset.top)) {
            self.autoScroll = .kAutoScrollUp
            
            return true
        }
        
        // imageView拖动到tableView底部，且tableView没有滚动到最下面
        if (self.cellImageView!.frame.maxY > (self.contentOffset.y + self.frame.height - self.contentInset.bottom) && (self.contentOffset.y < (self.contentSize.height - self.frame.height + self.contentInset.bottom))) {
            self.autoScroll = .kAutoScrollDown
            
            return true
        }
        
        return false
    }
    
    private func startTimerToScrollTableView() {
        self.displayLink?.invalidate()
        self.displayLink = CADisplayLink.init(target: self, selector: #selector(scrollTableView))
        self.displayLink?.add(to: RunLoop.current, forMode: .common)
    }
    
    @objc private func scrollTableView() {
        // 如果已经滚动到最上面或最下面，则停止定时器并返回
        if (self.autoScroll == .kAutoScrollUp && self.contentOffset.y <= -self.contentInset.top) || (self.autoScroll == .kAutoScrollDown && self.contentOffset.y >= self.contentSize.height - self.frame.height + self.contentInset.bottom)  {
            self.displayLink?.invalidate()
            return
        }
        
        // 改变tableView的contentOffset，实现自动滚动
        let height: CGFloat = self.autoScroll == .kAutoScrollUp ? -self.scrollSpeed : self.scrollSpeed
        var point: CGPoint = self.contentOffset
        point.y += height
        self.setContentOffset(point, animated: false)
        
        // 改变cellImageView的位置为手指所在位置
        var center: CGPoint = self.cellImageView!.center
        center.y += height
        self.cellImageView!.center = center
        
        // 滚动tableView的同时改变当前手指触摸所处的位置
        let toIndexPath = self.indexPathForRow(at: self.cellImageView!.center)
        if toIndexPath != nil && toIndexPath != self.fromIndexPath {
            self.moveCell(toIndexPath: toIndexPath!)
        }
    }
    
    /// 移动cell
    private func moveCell(toIndexPath: IndexPath) {
        if toIndexPath.section == self.fromIndexPath?.section {
//            self.exchangeValue(&self.dataArray, self.fromIndexPath!.row, toIndexPath.row)
            self.moveRow(at: toIndexPath, to: self.fromIndexPath!) // 切换cell
            
            self.fromIndexPath = toIndexPath
        } else {
            
//            if self.isDragToGroup {
//
//                self .beginUpdates()
//
//                // 先将cell的数据模型从之前的数组中移除，然后再插入新的数组
//                var fromSection: Array<Any> = self.dataArray[self.fromIndexPath!.section] as! Array<Any>
//                var toSection: Array<Any> = self.dataArray[toIndexPath.section] as! Array<Any>
//                let obj = fromSection[self.fromIndexPath!.row]
//                fromSection.remove(at: self.fromIndexPath!.row)
//                toSection.insert(obj, at: toIndexPath.row)
//
//                // 如果某个组的所有cell都被移动到其他组，则删除这个组
//                if fromSection.count == 0 {
//                    self.dataArray.removeAll()
//                }
//
//
//
//                self.endUpdates()
//            }
        }
    }
    
    
    
    private func createCellImageView(cell: UITableViewCell) -> UIImageView {
        UIGraphicsBeginImageContextWithOptions(cell.bounds.size, false, UIScreen.main.scale)
        cell.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let cellImageView = UIImageView.init(image: image)
        cellImageView.layer.shadowOffset = CGSize.init(width: -5.0, height: 0.0)
        cellImageView.layer.shadowRadius = 5.0
        
        self.addSubview(cellImageView)
        
        return cellImageView
    }

}


public extension LKDragTableView {
    // T：泛型，起到占位符的作用
    // inout：这个相当于编程语言概念中所谓的传址调用
    func exchangeValue<T>(_ nums: inout [T], _ a: Int, _ b: Int) {
        (nums[a], nums[b]) = (nums[b], nums[a])
    }
}
