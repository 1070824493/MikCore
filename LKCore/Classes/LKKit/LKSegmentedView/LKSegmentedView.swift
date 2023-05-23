//
//  LKSegmentedView.swift
//  LKCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit
import JXSegmentedView


public protocol LKSegmentedDelegate: AnyObject {
        
    /// 选中Item
    /// - Parameters:
    ///   - segmentedView: --
    ///   - index: 当前选中位置
    ///   - isClick: true: 点击选中，false: 滚动选中
    func segmentedView(_ segmentedView: LKSegmentedView?, didSelectedItemAt index: Int, isClick: Bool)
    
}

open class LKSegmentedView: UIView {

    public enum Style {
        /// 默认样式, title: 标题集，itemWidth: 每个Item的宽度，默认为自动, indicatorSize: 底部进度条的尺寸，默认为自动
        case default_(titles: [String], itemWidth: CGFloat?, indicatorSize: CGSize?)
    }
    
    weak public var delegate: LKSegmentedDelegate?
    
    private let style: Style
    private let defaultSelectedIndex: Int
    private let listContainerView: LKListContainerView
    
    private lazy var segmentedView: JXSegmentedView = createSetgmentedView(style: style)
    
    required public init(style: Style, defaultSelectedIndex: Int = 0, listContrainer: LKListContainerView) {
        self.style = style
        self.defaultSelectedIndex = defaultSelectedIndex
        self.listContainerView = listContrainer
        
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    public override init(frame: CGRect) {
        fatalError()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension LKSegmentedView {
    
    private func configure() {
        backgroundColor = UIColor.lk.color(.hexFFFFFF)
        segmentedView.defaultSelectedIndex = defaultSelectedIndex
        segmentedView.listContainer = listContainerView.listContrainer
    }
    
    private func setupSubviews() {
        addSubview(segmentedView)
    }
    
    private func setupSubviewsConstraints() {
        segmentedView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}


// MARK: - Private
extension LKSegmentedView {
        
    /// 生产不同的样式的JXSegmentedView
    /// - Parameter style: JXSegmentedView的样式
    private func createSetgmentedView(style: Style) -> JXSegmentedView {
        switch style {
        case .default_(let titles, let itemWidth, let indicatorSize):
            let defaultSegmentedView = DefaultSegmentedView(config: DefaultSegmentedView.Config(titles: titles, itemWidth: itemWidth, indicatorSize: indicatorSize))
            defaultSegmentedView.didSelectedItemHandler = { [weak self] (index, isClick) in
                self?.delegate?.segmentedView(self, didSelectedItemAt: index, isClick: isClick)
            }
            return defaultSegmentedView
        }
    }
    
}

// MARK: - Public
public extension LKSegmentedView {
    
    /// 设置当前选中项
    /// - Parameter index: 选中项下标
    func selectedItem(at index: Int) {
        self.segmentedView.selectItemAt(index: index)
    }
    
}
