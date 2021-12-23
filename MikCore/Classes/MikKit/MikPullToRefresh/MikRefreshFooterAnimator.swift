//
//  MikRefreshFooterAnimator.swift
//  MikCore
//
//  Created by yu12 on 2021/8/3.
//

import ESPullToRefresh
import Kingfisher
import Foundation

open class MikRefreshFooterAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol {

    open var loadingMoreDescription: String = NSLocalizedString("Loading more", comment: "")
    open var noMoreDataDescription: String  = NSLocalizedString("No more data", comment: "")
    open var loadingDescription: String     = NSLocalizedString("Loading...", comment: "")

    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 42.0
    open var executeIncremental: CGFloat = 42.0
    open var state: ESRefreshViewState = .pullToRefresh
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.mik.font(size: 14)
        label.textColor = UIColor.init(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var loadingImageView: AnimatedImageView = {
        let aImgView = AnimatedImageView()
        aImgView.clipsToBounds = true
        aImgView.contentMode = .scaleAspectFill
        aImgView.runLoopMode = .common
        aImgView.isHidden = true
        aImgView.autoPlayAnimatedImage = false
        
        if let sourcePath = Bundle.mik.default.path(forResource: "mik_pullToRefresh", ofType: "gif") {
            aImgView.kf.setImage(with: LocalFileImageDataProvider(fileURL: URL(fileURLWithPath: sourcePath), cacheKey: "com.mik.pullToRefresh"))
        }
        
        return aImgView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(loadingImageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        loadingImageView.startAnimating()
        titleLabel.text = loadingDescription
        loadingImageView.isHidden = false
        titleLabel.isHidden = true
    }
    
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        loadingImageView.stopAnimating()
        titleLabel.text = loadingMoreDescription
        loadingImageView.isHidden = true
        titleLabel.isHidden = false
    }
    
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing :
            titleLabel.text = loadingDescription
            break
        case .noMoreData:
            titleLabel.text = noMoreDataDescription
            break
        case .pullToRefresh:
            titleLabel.text = loadingMoreDescription
            break
        default:
            break
        }
        self.setNeedsLayout()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0 - 5.0)
        loadingImageView.center = self.center
        loadingImageView.frame.size = CGSize(width: 24, height: 24)
    }
}
