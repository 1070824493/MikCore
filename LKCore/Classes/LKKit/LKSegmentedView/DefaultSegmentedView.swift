//
//  DefaultSegmentedView.swift
//  LKCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import JXSegmentedView

class DefaultSegmentedView: JXSegmentedView {
    
    public struct Config {
        var titles: [String]
        /// Item 的宽度，默认为内容长度 + 32
        var itemWidth: CGFloat?
        /// 底部进度条的尺寸， 默认宽度为内容长度，高度为2
        var indicatorSize: CGSize?
    }
    
    /// 选中回调, index: 当前选中位置, isClick: 标记是点击选中还是滑动选中
    var didSelectedItemHandler: ((_ index: Int, _ isClick: Bool) -> Void)?
    
    private let config: Config
    
    private lazy var titleDataSource: JXSegmentedTitleDataSource = {
        let aTitleDataSource = JXSegmentedTitleDataSource()
        aTitleDataSource.isTitleColorGradientEnabled = true
        aTitleDataSource.isItemSpacingAverageEnabled = false
        aTitleDataSource.isItemTransitionEnabled = true
        aTitleDataSource.isSelectedAnimable = true
        aTitleDataSource.isTitleZoomEnabled = false
        aTitleDataSource.titleNormalFont = UIFont.lk.font(.nunitoSansBold, size: 14)
        aTitleDataSource.titleSelectedFont = UIFont.lk.font(.nunitoSansBold, size: 14)
        aTitleDataSource.titleNormalColor = UIColor.lk.text(.hex1B1B1B)
        aTitleDataSource.titleSelectedColor = UIColor.lk.text(.hexCF1F2E)
        aTitleDataSource.titles = config.titles
        aTitleDataSource.itemSpacing = 0
        aTitleDataSource.itemWidth = {
            guard let itemWidth = config.itemWidth, itemWidth > 0 else {
                return JXSegmentedViewAutomaticDimension
            }
            return itemWidth
        }()
        aTitleDataSource.itemWidthIncrement = {
            guard let itemWidth = config.itemWidth, itemWidth > 0 else {
                return 32
            }
            return 0
        }()
        return aTitleDataSource
    }()

    required init(config: Config) {
        self.config = config
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension DefaultSegmentedView {
    
    private func configure() {
        dataSource = titleDataSource
        delegate = self
        isContentScrollViewClickTransitionAnimationEnabled = false
        indicators = [LKSegmentedIndicatorLineView(indicatorSize: self.config.indicatorSize)]
        if #available(iOS 11.0, *) {
            contentScrollView?.contentInsetAdjustmentBehavior = .never
            collectionView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    private func setupSubviews() {}
    
    private func setupSubviewsConstraints() {}
    
}

// MARK: - JXSegmentedViewDelegate
extension DefaultSegmentedView: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didClickSelectedItemAt index: Int) {
        self.didSelectedItemHandler?(index, true)
        self.listContainer?.didClickSelectedItem(at: index)
    }
    
    func segmentedView(_ segmentedView: JXSegmentedView, didScrollSelectedItemAt index: Int) {
        self.didSelectedItemHandler?(index, false)
    }
    
}

// MARK: - LKSegmentedIndicatorLineView
fileprivate class LKSegmentedIndicatorLineView: JXSegmentedIndicatorLineView {
    
    required init(indicatorSize: CGSize? = nil) {
        super.init(frame: .zero)
        backgroundColor = UIColor.lk.general(.hexCF1F2E)
        
        lineStyle = .lengthenOffset
        isIndicatorWidthSameAsItemContent = true
        verticalOffset = 0
        indicatorWidth = indicatorSize?.width ?? JXSegmentedViewAutomaticDimension
        indicatorHeight = indicatorSize?.height ?? 2
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
