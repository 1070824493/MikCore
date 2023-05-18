//
//  LKPopupHoverViewController.swift
//  LKCore
//
//  Created by m7 on 2022/3/19.
//

import UIKit
import SnapKit


public typealias LKHoverViewController = LKBaseViewController & LKPopupHoverDataConfigures
public typealias LKHoverParentController = LKBaseViewController & LKPopupHoverParentConfig
public typealias LKPopupCompletion = () -> Void

public protocol LKPopupHoverParentConfig {
            
    /// 获取响应事件的响应视图
    /// - Parameter point: 以 'window' 坐标系的坐标点
    /// - Returns: 响应视图
    func responderView(_ point: CGPoint) -> UIView?
    
}

public extension LKPopupHoverParentConfig {
    
    var responderView: UIView? { nil }
    
}

public protocol LKPopupHoverDataConfigures {
    
    /// 容器宽度
    var contentWidth: CGFloat { get }
    /// 容器可悬停高度，容器默认高度为第一个值
    var hoverHeights: [CGFloat] { get }
    /// 背景透明度
    var dimmingAlpha: CGFloat { get }
    /// 容器圆角
    var contentCornerRadius: CGFloat? { get }
    /// 容器是否跟随手指滑动
    var isPanEnable: Bool { get }
    
}

public extension LKPopupHoverDataConfigures {
    
    var contentWidth: CGFloat { UIScreen.main.bounds.width }
    
    var dimmingAlpha: CGFloat { 0.5 }
    
    var contentCornerRadius: CGFloat? { 16 }
    
    var isPanEnable: Bool { true }
    
}

public enum LKPopupHoverStyle {
    
    case modal, parent
    
}

fileprivate enum PanDirection {
    
    case up, down
    
}


open class LKPopupHoverViewController: LKBaseViewController {
    
    typealias DimmingRangeTuple = (min: CGFloat, max: CGFloat)
        
    /// 'ContenView' 高度变化回调
    public var contentHeightChangedHandler: ((CGFloat) -> Void)?
    
    private typealias HoverRangeTuple = (min: CGFloat, max: CGFloat)
        
    private let hoverController: LKHoverViewController
    
    private weak var hoverParentViewController: LKHoverParentController?
        
    /// 可滑动范围
    private let hoverRange: HoverRangeTuple
    
    /// 背景调光范围
    private let dimmingRangeTuple: DimmingRangeTuple
    
    /// 滑动方向
    private var panDirection: PanDirection?
    
    private var style: LKPopupHoverStyle?
    
    /// 目标悬停高度
    private var targetHoverHeight: CGFloat {
        didSet {
            guard targetHoverHeight != oldValue else { return }
            self.contentHeightChangedHandler?(targetHoverHeight)
        }
    }
    
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let aPan = UIPanGestureRecognizer(target: self, action: #selector(didPanHandle(_:)))
        aPan.cancelsTouchesInView = false
        return aPan
    }()
    
    private lazy var contentView: UIView = {
        let aView = UIView()
        aView.backgroundColor = .clear
        aView.addGestureRecognizer(panGestureRecognizer)
        return aView
    }()
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        configure()
        setupSubviews()
        setupSubviewsFrame()
    }
    
    public override func loadView() {
        view = {
            let aView = PopupHoverView()
            aView.responderView = { [weak self] point in
                guard self?.contentView.frame.contains(point) ?? false else {
                    if let bPoint = self?.view?.convert(point, to: UIApplication.shared.lk.legacyKeyWindow) {
                        return self?.hoverParentViewController?.responderView(bPoint)
                    }
                    return nil
                }
                return nil
            }
            return aView
        }()
    }
    
    required public init(hoverViewController: LKHoverViewController) {
        hoverController = hoverViewController
        targetHoverHeight = hoverViewController.hoverHeights.first ?? 0
        hoverRange = {
            let sortHoverHeights = hoverViewController.hoverHeights.sorted(by: { $0 < $1 })
            return (sortHoverHeights.first ?? 0, sortHoverHeights.last ?? 0)
        }()
        dimmingRangeTuple = {
            var sortHoverHeights = hoverViewController.hoverHeights.sorted(by: { $0 > $1 })
            let max = sortHoverHeights.first ?? 0
            let min = sortHoverHeights.first(where: { $0 != max }) ?? 0
            return (min, max)
        }()
        
        super.init(nibName: nil, bundle: nil)
        
        modalPresentationStyle = .custom
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(nibName:, nibName:) has not been implemented")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("*** \(String(describing: self)) deinit ***♻️")
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        view.endEditing(true)
        touchMoved(touches.first)
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        toucheEnded(self.panGestureRecognizer)
    }
    
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        toucheEnded(self.panGestureRecognizer)
    }
    
}


// MARK: - Assistant
extension LKPopupHoverViewController {
    
    private func configure() {
        view.backgroundColor = UIColor.lk.general(.hex000000, alpha: 0)
        lk_navigationBarColor = .clear
        
        addChild(hoverController)
        hoverController.didMove(toParent: self)
    }
    
    private func setupSubviews() {
        func addSubviews() {
            view.addSubview(contentView)
            contentView.addSubview(hoverController.view)
        }
        
        func setupLayers() {
            if let contentCornerRadius = hoverController.contentCornerRadius,
                  contentCornerRadius > 0 {
                hoverController.view.layer.cornerRadius = contentCornerRadius
                hoverController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                hoverController.view.layer.masksToBounds = true
            }
            
            contentView.lk.setShadowWithCorners(size: CGSize(width: hoverController.contentWidth, height: 60),
                                                 roundingCorners: [.topLeft, .topRight],
                                                 cornerRadius: hoverController.contentCornerRadius ?? 0,
                                                 shadowColor: UIColor.lk.hex(0x000000, alpha: 0.2),
                                                 shadowOffset: CGSize(width: 0, height: 2),
                                                 shadowRadius: 16)
        }
        
        addSubviews()
        setupLayers()
    }
    
    private func setupSubviewsFrame() {
        defer { hoverController.view.frame = contentView.bounds }
        contentView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: hoverController.contentWidth, height: targetHoverHeight)
    }
    
}

// MARK: - Private
extension LKPopupHoverViewController {
    
    @objc
    private func didPanHandle(_ sender: UIPanGestureRecognizer) { }
    
    private func updateContentHeight(height: CGFloat, animated: Bool) {
        defer {
            self.updateDimmingAlpha(contentViewHeight: self.targetHoverHeight, animated: animated)
            
            if animated {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                    self.updateSubViewsFrame(contentViewHeight: self.targetHoverHeight)
                }, completion: nil)
            }else {
                self.updateSubViewsFrame(contentViewHeight: self.targetHoverHeight)
            }
        }
        
        self.targetHoverHeight = min(hoverRange.max, max(hoverRange.min, height))
    }
    
    private func updateSubViewsFrame(contentViewHeight: CGFloat) {
        defer {
            self.hoverController.view.frame = self.contentView.bounds
        }
        
        self.contentView.frame = CGRect(x: 0, y: self.view.bounds.height - contentViewHeight, width: self.hoverController.contentWidth, height: contentViewHeight)
    }
    
    private func updateDimmingAlpha(contentViewHeight: CGFloat, animated: Bool) {
        let heightDiff = self.dimmingRangeTuple.max - self.dimmingRangeTuple.min
        
        guard heightDiff > 0, self.hoverController.dimmingAlpha > 0 else { return }
        
        let percent = (contentViewHeight - dimmingRangeTuple.min) / heightDiff
        
        let backgroundColor = UIColor.lk.general(.hex000000, alpha: self.hoverController.dimmingAlpha * percent)
        
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.view.backgroundColor = backgroundColor
            }
        }else {
            self.view.backgroundColor = backgroundColor
        }
    }
    
    private func touchMoved(_ touch: UITouch?) {
        guard self.hoverController.isPanEnable, let touch = touch else { return }

        let location = touch.preciseLocation(in: self.contentView)
        let previousLocation = touch.precisePreviousLocation(in: self.contentView)
        
        // 滑动距离
        let distanceValue = previousLocation.y - location.y
        let bContentHeight = self.targetHoverHeight + distanceValue
        
        self.panDirection = distanceValue > 0 ? .up : .down
        
        self.updateContentHeight(height: bContentHeight, animated: false)
    }
    
    private func toucheEnded(_ pan: UIPanGestureRecognizer) {
        guard self.hoverController.isPanEnable else { return }
        
        let velocity = pan.velocity(in: self.contentView).y
        
        var finalHeight: CGFloat?
        
        switch (self.panDirection, velocity) {
        case (.up, 1000...):
            finalHeight = self.hoverController.hoverHeights
                .filter({ $0 > self.targetHoverHeight })
                .sorted(by: { $0 < $1 })
                .first
        case (.down, 1000...):
            finalHeight = self.hoverController.hoverHeights
                .filter({ $0 < self.targetHoverHeight })
                .sorted(by: { $0 > $1 })
                .first
        default:
            var distance = CGFloat.infinity
            self.hoverController.hoverHeights.forEach({ height in
                let dis: CGFloat = abs(height - self.targetHoverHeight)
                if dis < distance {
                    finalHeight = height
                    distance = dis
                }
            })
        }
        
        guard let finalHeight = finalHeight else { return }
        
        self.updateContentHeight(height: finalHeight, animated: true)
    }
    
    /// 模态显示
    /// - Parameters:
    ///   - viewController: presentationController viewController
    ///   - completion: 显示完成回调
    private func present(in viewController: UIViewController?, completion: LKPopupCompletion? = nil) {
        guard let viewController = viewController else { return }
        
        func startPopupAnimation() {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.updateSubViewsFrame(contentViewHeight: self.targetHoverHeight)
            }
        }
        
        viewController.present(self, animated: false, completion: {
            completion?()
            startPopupAnimation()
            self.updateDimmingAlpha(contentViewHeight: self.targetHoverHeight, animated: true)
        })
    }
    
    /// 隐藏
    /// - Parameter completion: 隐藏完成回调
    private func dismiss(completion: LKPopupCompletion? = nil) {
        self.updateDimmingAlpha(contentViewHeight: 0, animated: true)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.contentView.frame = {
                var oldFrame = self.contentView.frame
                oldFrame.origin.y = UIScreen.main.bounds.height
                return oldFrame
            }()
        } completion: { _ in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
    /// 添加并显示到父控制器
    /// - Parameters:
    ///   - parentViewController: 父控制器
    ///   - completion: 显示完成回调
    private func moveToParentViewController(_ parentViewController: LKHoverParentController?, completion: LKPopupCompletion? = nil) {
        guard let hoverParentViewController = parentViewController else { return }
        
        func startPopupAnimation() {
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut, animations: {
                self.updateSubViewsFrame(contentViewHeight: self.targetHoverHeight)
            }, completion: { _ in
                completion?()
            })
        }
        
        func moveToParent() {
            hoverParentViewController.addChild(self)
            self.didMove(toParent: hoverParentViewController)
            hoverParentViewController.view.addSubview(self.view)
            self.view.frame = hoverParentViewController.view.bounds
        }
        
        defer {
            startPopupAnimation()
            self.updateDimmingAlpha(contentViewHeight: self.targetHoverHeight, animated: true)
        }
        
        self.hoverParentViewController = hoverParentViewController
        moveToParent()
    }
    
    /// 从父控制器移除
    /// - Parameter completion: 移除完成回调
    private func removeFromParentViewController(completion: LKPopupCompletion? = nil) {
        self.updateDimmingAlpha(contentViewHeight: 0, animated: true)
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
            self.contentView.frame = {
                var oldFrame = self.contentView.frame
                oldFrame.origin.y = UIScreen.main.bounds.height
                return oldFrame
            }()
        } completion: { _ in
            self.view.removeFromSuperview()
            self.removeFromParent()
            completion?()
        }
    }
    
}


// MARK: - Public
extension LKPopupHoverViewController {
    
    /// 显示
    /// - Parameters:
    ///   - viewController: 父控制器，用于加载自控制器或模态跳转
    ///   - style: 显示类型
    ///   - completion: 显示完成回调
    public func show(in viewController: LKHoverParentController, style: LKPopupHoverStyle, completion: LKPopupCompletion? = nil) {
        self.style = style
        
        switch style {
        case .modal:
            self.present(in: viewController, completion: completion)
        case .parent:
            self.moveToParentViewController(viewController, completion: completion)
        }
    }
    
    /// 隐藏
    /// - Parameter completion: 隐藏回调
    public func hidden(completion: LKPopupCompletion? = nil) {
        switch self.style {
        case .modal:
            self.dismiss(completion: completion)
        case .parent:
            self.removeFromParentViewController(completion: completion)
        default:
            return
        }
    }
    
    /// 设置悬停位置
    /// - Parameters:
    ///   - height: 悬停高度
    ///   - animated: 是否动画
    public func setupHover(height: CGFloat, animated: Bool) {
        guard self.hoverController.hoverHeights.contains(height) else { return }
        self.updateContentHeight(height: height, animated: true)
    }
    
}


// MARK: - PopupHoverView
fileprivate class PopupHoverView: UIView {
    
    var responderView: ((CGPoint) -> UIView?)?
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return responderView?(point) ?? super.hitTest(point, with: event)
    }
    
}
