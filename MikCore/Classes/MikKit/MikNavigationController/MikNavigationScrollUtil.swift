//
//  MikNavigationScrollUtil.swift
//  MikCore
//
//  Created by ty on 2022/2/24.
//

import RxCocoa
import RxSwift
import UIKit

public let kTabbarHiddenAnimationDuration = 0.25

class MikNavigationScrollUtil {
    let vc: UIViewController

    let disposeBag = DisposeBag()

    let scrollView: UIScrollView?

    var previousOffsetY: CGFloat?

    var isTabbarHidden = false

    init(viewController: UIViewController) {
        vc = viewController
        scrollView = MikNavigationScrollUtil.findScrollView(view: viewController.view)
        obseverScrollView()
    }

    func updateTabbarHiddenStatus(isHidden: Bool) {
        guard let tabbar = self.vc.tabBarController?.tabBar else { return }
        UIView.animate(withDuration: kTabbarHiddenAnimationDuration) {
            if isHidden {
                var frame = tabbar.frame
                frame.origin.y = UIScreen.mik.height
                tabbar.frame = frame

            } else {
                var frame = tabbar.frame
                frame.origin.y = UIScreen.mik.height - UIViewController.mik.safeAreaMax.bottom
                tabbar.frame = frame
            }
        } completion: { _ in
            self.isTabbarHidden = tabbar.frame.minY == UIScreen.mik.height
            NotificationCenter.default.post(name: .kTabbarDidChangeByScrollNotification, object: self.isTabbarHidden)
        }
    }

    func obseverScrollView() {
        guard let scrollView = scrollView, let tabbar = self.vc.tabBarController?.tabBar else { return }

        scrollView.rx.contentOffset
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self, let previousOffsetY = self.previousOffsetY else { return }

                let contentOffsetY = scrollView.contentOffset.y
                let deltaY = contentOffsetY - previousOffsetY

                guard abs(deltaY) > 44 else { return }

                var fy: CGFloat = 0
                if deltaY > 0 {
                    if self.isTabbarHidden == true {
                        return
                    }
                    fy = UIScreen.mik.height - UIViewController.mik.safeAreaMax.bottom + min(deltaY - 44, UIViewController.mik.safeAreaMax.bottom)
                } else {
                    if self.isTabbarHidden == false {
                        return
                    }
                    // 手指往下滑动
                    fy = UIScreen.mik.height - min(abs(deltaY) - 44, UIViewController.mik.safeAreaMax.bottom)
                }
                var rect = tabbar.frame
                rect.origin.y = fy
                tabbar.frame = rect

            })
            .disposed(by: disposeBag)

        scrollView.rx.willBeginDragging
            .subscribe(onNext: { [weak self] _ in
                self?.previousOffsetY = scrollView.contentOffset.y
            })
            .disposed(by: disposeBag)

        scrollView.rx.didEndDragging
            .subscribe(onNext: { [weak self] _ in
                guard let `self` = self, let previousOffsetY = self.previousOffsetY else { return }

                self.previousOffsetY = nil
                let deltaY = scrollView.contentOffset.y - previousOffsetY
                if abs(deltaY) > 44 {
                    NotificationCenter.default.post(name: .kTabbarWillChangeByScrollNotification, object: deltaY > 0)
                    self.updateTabbarHiddenStatus(isHidden: deltaY > 0)
                }
            })
            .disposed(by: disposeBag)
    }

    static func findScrollView(view: UIView) -> UIScrollView? {
        if let tableview = view as? UIScrollView {
            return tableview
        }

        for v in view.subviews {
            if v.isKind(of: UIScrollView.self) {
                return v as? UIScrollView
            }
            return findScrollView(view: v)
        }

        return nil
    }
}

public extension Notification.Name {
    static let kTabbarWillChangeByScrollNotification = Notification.Name("kTabbarWillChangeByScrollNotification")
    static let kTabbarDidChangeByScrollNotification = Notification.Name("kTabbarDidChangeByScrollNotification")
}
