//
//  MikRefreshHeaderAnimator.swift
//  MikFoundation
//
//  Created by yu12 on 2021/4/19.
//

import ESPullToRefresh
import Kingfisher
import Foundation

open class MikRefreshHeaderAnimator: UIView, ESRefreshProtocol, ESRefreshAnimatorProtocol, ESRefreshImpactProtocol {
    open var pullToRefreshDescription = NSLocalizedString("Pull to refresh", comment: "") {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription;
            }
        }
    }
    open var releaseToRefreshDescription = NSLocalizedString("Release to refresh", comment: "")
    open var loadingDescription = NSLocalizedString("Loading...", comment: "")

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    open var state: ESRefreshViewState = .pullToRefresh

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView.init()
        let frameworkBundle = Bundle(for: ESRefreshAnimator.self)
        if /* CocoaPods static */ let path = frameworkBundle.path(forResource: "ESPullToRefresh", ofType: "bundle"),let bundle = Bundle(path: path) {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        }else if /* Carthage */ let bundle = Bundle.init(identifier: "com.eggswift.ESPullToRefresh") {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else if /* CocoaPods */ let bundle = Bundle.init(identifier: "org.cocoapods.ESPullToRefresh") {
            imageView.image = UIImage(named: "ESPullToRefresh.bundle/icon_pull_to_refresh_arrow", in: bundle, compatibleWith: nil)
        } else /* Manual */ {
            imageView.image = UIImage(named: "icon_pull_to_refresh_arrow")
        }
        return imageView
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
    
    fileprivate let titleLabel: UILabel = {
        let label = UILabel.init(frame: CGRect.zero)
        label.font = UIFont.mik.font(size: 14)
        label.textColor = UIColor.init(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(loadingImageView)
    }
    
    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func refreshAnimationBegin(view: ESRefreshComponent) {
        loadingImageView.isHidden = false
        loadingImageView.startAnimating()
        imageView.isHidden = true
        titleLabel.isHidden = true
        titleLabel.text = loadingDescription
        imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
    }
  
    open func refreshAnimationEnd(view: ESRefreshComponent) {
        loadingImageView.isHidden = true
        loadingImageView.stopAnimating()
        imageView.isHidden = false
        titleLabel.isHidden = false
        titleLabel.text = pullToRefreshDescription
        imageView.transform = CGAffineTransform.identity
    }
    
    open func refresh(view: ESRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
        
    }
    
    open func refresh(view: ESRefreshComponent, stateDidChange state: ESRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state
        
        switch state {
        case .refreshing, .autoRefreshing:
            titleLabel.text = loadingDescription
            self.setNeedsLayout()
            break
        case .releaseToRefresh:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            self.impact()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
            }) { (animated) in }
            break
        case .pullToRefresh:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: {
                [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            }) { (animated) in }
            break
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let s = self.bounds.size
        let w = s.width
        let h = s.height
        
        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint.init(x: w / 2.0, y: h / 2.0)
            loadingImageView.center = self.center
            loadingImageView.frame.size = CGSize(width: 24, height: 24)
            imageView.frame = CGRect.init(x: titleLabel.frame.origin.x - 28.0, y: (h - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }
    
}
