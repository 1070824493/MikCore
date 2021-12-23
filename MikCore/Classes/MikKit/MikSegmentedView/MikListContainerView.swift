//
//  MikListContainerView.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit
import JXSegmentedView


public typealias MikSegmentedListContainerViewListDelegate = JXSegmentedListContainerViewListDelegate
public typealias MikSegmentedViewListContainer = JXSegmentedViewListContainer

public protocol MikListContainerViewDelegate: AnyObject {
    
    func numberOfLists(in listContainerView: MikListContainerView) -> Int
    
    func listContainerView(_ listContainerView: MikListContainerView, initListAt index: Int) -> MikSegmentedListContainerViewListDelegate
    
}

open class MikListContainerView: UIView {
    
    public weak var delegate: MikListContainerViewDelegate?
    
    public lazy var listContrainer: MikSegmentedViewListContainer = self.listContainerView
    
    public lazy var contentScrollView: UIScrollView = self.listContainerView.contentScrollView()
    
    private lazy var listContainerView: JXSegmentedListContainerView = JXSegmentedListContainerView(dataSource: self)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard let _ = self.superview, listContainerView.superview == nil else { return }
        
        addSubview(listContainerView)
        listContainerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

// MARK: - Assistant
extension MikListContainerView {
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
    }
    
    private func setupSubviews() {}
    
    private func setupSubviewsConstraints() {}
    
}

// MARK: - JXSegmentedListContainerViewDataSource
extension MikListContainerView: JXSegmentedListContainerViewDataSource {
    
    public func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return self.delegate?.numberOfLists(in: self) ?? 0
    }
    
    public func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.delegate!.listContainerView(self, initListAt: index)
    }
    
}
