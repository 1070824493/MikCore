//
//  LKListContainerViewController.swift
//  LKCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit

class LKListContainerViewController: LKBaseViewController {

    private let titles: [String] = (0 ..< 5).map({ "item \($0)" })
    
    private lazy var segmentedView: LKSegmentedView = {
        let segmentedView = LKSegmentedView(style: .default_(titles: titles, itemWidth: nil, indicatorSize: nil), defaultSelectedIndex: 0, listContrainer: lisContainerView)
        segmentedView.delegate = self
        return segmentedView
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        /// 指定选中项
        segmentedView.selectedItem(at: 2)
    }
    
//    private lazy var segmentedView: LKSegmentedView = LKSegmentedView(style: .default_(titles: titles, itemWidth: UIScreen.main.bounds.width / 2, indicatorSize: CGSize(width: UIScreen.main.bounds.width / 2, height: 2)), defaultSelectedIndex: 0, listContrainer: lisContainerView)
    
    private lazy var lisContainerView: LKListContainerView = {
        let aLisConstrainer = LKListContainerView()
        aLisConstrainer.delegate = self
//        aLisConstrainer.contentScrollView.isScrollEnabled = false
        return aLisConstrainer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        segmentedView.listContrainer = self.lisContainerView
        
        view.addSubview(lisContainerView)
        view.addSubview(segmentedView)
        
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(UIViewController.lk.safeAreaMax.top)
            make.width.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        lisContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

}

// MARK: - LKSegmentedListContainerDataSource
extension LKListContainerViewController: LKListContainerViewDelegate {
    
    func numberOfLists(in listContainerView: LKListContainerView) -> Int {
        return self.titles.count
    }
    
    func listContainerView(_ listContainerView: LKListContainerView, initListAt index: Int) -> LKSegmentedListContainerViewListDelegate {
        return TestListContraintsViewController()
    }
    
}

// MARK: - LKSegmentedDelegate
extension LKListContainerViewController: LKSegmentedDelegate {
    func segmentedView(_ segmentedView: LKSegmentedView?, didSelectedItemAt index: Int, isClick: Bool) {
        print("did selected item at index: \(index), is click: \(isClick)")
    }
}
