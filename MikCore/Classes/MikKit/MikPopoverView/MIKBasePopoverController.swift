//
//  MIKPopoverController.swift
//  MLDemo
//
//  Created by raoml on 2019/5/9.
//  Copyright © 2019 raoml. All rights reserved.
//

import UIKit

open class MIKPopoverController: UIViewController {
    
    public struct Config {
        public init() { }
        
        var backgroundColor: UIColor = .clear
        var arrowSize: CGSize = CGSize(width: 10, height: 5)
        var arrowColor: UIColor = UIColor.mik.hex(0x1B1B1B)
        var space: CGFloat = 0
    }

    public enum PopoverDirection {
        case up
        case down
        case left
        case right
        // 横向自动
        case autoHorizontal
        // 纵向自动
        case autoVertical
    }
    
    /// 将要消失
    public var willDismissBlock: (() -> Void)?
    
    private let config: Config
    private let coustomView: UIView
    private let convertFrame: CGRect
    private var direction: PopoverDirection
    
    weak private var showInViewController: UIViewController?
    
    private lazy var mContentView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.clear
        aView.addSubview(self.coustomView)
        return aView
    }()
    
    override open func loadView() {
        super.loadView()
        view = {
            let aView = PCView(frame: UIScreen.main.bounds, config: config, direction: direction, convertFrame: convertFrame)
            aView.alpha = 0
            return aView
        }()
    }
    
    required public init(config: Config = Config(), customView: UIView, direction: PopoverDirection, showInViewController: UIViewController, convertFrame: CGRect) {
        self.config = config
        self.coustomView = customView
        self.convertFrame = convertFrame
        self.direction = direction
        
        super.init(nibName: nil, bundle: nil)
        
        self.showInViewController = showInViewController
        
        self.modalTransitionStyle = .crossDissolve
        self.modalPresentationStyle = .overCurrentContext
        self.modalPresentationCapturesStatusBarAppearance = true
    }
    
    convenience public init(config: Config = Config(), customView: UIView, direction: PopoverDirection, showInViewController: UIViewController, fromView: UIView) {
        let convertFrame = showInViewController.view.convert(fromView.bounds, from: fromView)
        self.init(config: config, customView: customView, direction: direction, showInViewController: showInViewController, convertFrame: convertFrame)
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        // 确定具体的显示方向
        switch self.direction {
            case .autoHorizontal:
                if self.convertFrame.midX > self.view.bounds.midX {
                    self.direction = .left
                }else {
                    self.direction = .right
                }
            case .autoVertical:
                if self.convertFrame.midY > self.view.bounds.midY {
                    self.direction = .up
                }else {
                    self.direction = .down
                }
            default:
                break
        }
        
        self.setupUI()
        self.setSubviewsConstraints()
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var tapPoint: CGPoint = (touches.first?.location(in: self.view))!
        tapPoint = self.mContentView.layer.convert(tapPoint, from: self.view.layer)
        if self.mContentView.layer.contains(tapPoint) == false {
            self.hidden(completion: nil)
        }
    }
    
    deinit {
        print("*** \(String(describing: type(of: self))) deinit ***♻️")
    }

}

// MARK: - Private Meds
private extension MIKPopoverController {
    
    private func setupUI() {
        self.view.addSubview(self.mContentView)
    }
    
    private func setSubviewsConstraints() {
        self.coustomView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.size.lessThanOrEqualTo(self.view).priority(.required)
        }
        
        switch self.direction {
            case .up:
                self.mContentView.snp.makeConstraints { (make) in
                    make.left.greaterThanOrEqualToSuperview().priority(.high)
                    make.right.lessThanOrEqualToSuperview().priority(.high)
                    make.centerX.equalTo(self.convertFrame.midX).priority(.low)
                    make.top.greaterThanOrEqualToSuperview()
                    make.bottom.equalTo(self.view.snp.top).offset(self.convertFrame.minY - self.config.space - self.config.arrowSize.height)
                }
            case .down:
                self.mContentView.snp.makeConstraints { (make) in
                    make.left.greaterThanOrEqualToSuperview().priority(.high)
                    make.right.lessThanOrEqualToSuperview().priority(.high)
                    make.centerX.equalTo(self.convertFrame.midX).priority(.low)
                    make.top.equalToSuperview().offset(self.convertFrame.maxY + self.config.space + self.config.arrowSize.height)
                    make.bottom.lessThanOrEqualToSuperview()
                }
            case .left:
                self.mContentView.snp.makeConstraints { (make) in
                    make.top.greaterThanOrEqualToSuperview().priority(.high)
                    make.bottom.lessThanOrEqualToSuperview().priority(.high)
                    make.centerY.equalTo(self.convertFrame.midY).priority(.low)
                    make.left.greaterThanOrEqualToSuperview()
                    make.right.equalTo(self.view.snp.left).offset(self.convertFrame.minX - self.config.space - self.config.arrowSize.height)
                }
            case .right:
                self.mContentView.snp.makeConstraints { (make) in
                    make.top.greaterThanOrEqualToSuperview().priority(.high)
                    make.bottom.lessThanOrEqualToSuperview().priority(.high)
                    make.centerY.equalTo(self.convertFrame.midY).priority(.low)
                    make.left.equalToSuperview().offset(self.convertFrame.maxX + self.config.space + self.config.arrowSize.height)
                    make.right.lessThanOrEqualToSuperview()
                }
            default:
                break
        }
    }
    
    /// 显示动画
    private func showAnimation() {
        // 动画时长
        let animationDuration: TimeInterval = 0.05
        // 缩放比列
        let transScale: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
        // 初始Transform
        var startTransform: CGAffineTransform!
        
        switch self.direction {
            case .up:
            startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: 0.5*transScale.y*self.mContentView.bounds.height))
            case .down:
                startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: -0.5*transScale.y*self.mContentView.bounds.height))
            case .left:
                startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0.5*transScale.x*self.mContentView.bounds.width, y: 0))
            case .right:
                startTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: -0.5*transScale.x*self.mContentView.bounds.width, y: 0))
            default:
                return
            }
        
        self.mContentView.transform = startTransform
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.alpha = 1
            self.mContentView.transform = .identity
        })
    }
    
    private func hiddenAnimation(completion: ((_ finish: Bool) -> Void)?) {
        // 动画时长
        let animationDuration: TimeInterval = 0.15
        // 缩放比列
        let transScale: (x: CGFloat, y: CGFloat) = (0.5, 0.5)
        // 初始Transform
        var endTransform: CGAffineTransform!
        
        switch self.direction {
        case .up:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: 0.5*transScale.y*self.mContentView.bounds.height))
        case .down:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0, y: -0.5*transScale.y*self.mContentView.bounds.height))
        case .left:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: 0.5*transScale.x*self.mContentView.bounds.width, y: 0))
        case .right:
            endTransform = CGAffineTransform(scaleX: transScale.x, y: transScale.y).concatenating(CGAffineTransform(translationX: -0.5*transScale.x*self.mContentView.bounds.width, y: 0))
        default:
            return
        }
        
        UIView.animate(withDuration: animationDuration, animations: {
            self.view.alpha = 0
            self.mContentView.transform = endTransform
        }, completion: completion)
    }
    
}

// MARK: - Public Meds
public extension MIKPopoverController {
    
    /**
     显示
     @param completion 显示动画完成回调
     */
    func show(completion: (() -> Void)? = nil) {
        self.showInViewController?.present(self, animated: false) {
            completion?()
            self.showAnimation()
        }
    }
    
    /**
     隐藏
     @param completion 隐藏回调
     */
    func hidden(completion: (() -> Void)? = nil) {
        self.willDismissBlock?()
        self.hiddenAnimation { (_) in
            self.dismiss(animated: false, completion: completion)
        }
    }
    
}

fileprivate class PCView: UIView {
    
    public let config: MIKPopoverController.Config
    public let direction: MIKPopoverController.PopoverDirection
    public let convertFrame: CGRect
    
    required init(frame: CGRect, config: MIKPopoverController.Config, direction: MIKPopoverController.PopoverDirection, convertFrame: CGRect) {
        self.config = config
        self.direction = direction
        self.convertFrame = convertFrame
        
        super.init(frame: frame)
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        let arrowBezier = UIBezierPath()
        switch self.direction {
        case .up:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.midX - self.config.arrowSize.width/2.0, y: self.convertFrame.minY - self.config.space - self.config.arrowSize.height))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX, y: self.convertFrame.minY - self.config.space))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX + self.config.arrowSize.width/2.0, y: self.convertFrame.minY - self.config.space - self.config.arrowSize.height))
        case .down:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.midX - self.config.arrowSize.width/2.0, y: self.convertFrame.maxY + self.config.space + self.config.arrowSize.height))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX, y: self.convertFrame.maxY + self.config.space))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.midX + self.config.arrowSize.width/2.0 , y: self.convertFrame.maxY + self.config.space + self.config.arrowSize.height))
        case .left:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.minX - self.config.space - self.config.arrowSize.height, y: self.convertFrame.midY - self.config.arrowSize.width/2.0))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.minX - self.config.space, y: self.convertFrame.midY))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.minX - self.config.space - self.config.arrowSize.height, y: self.convertFrame.midY + self.config.arrowSize.width/2.0))
        case .right:
            arrowBezier.move(to: CGPoint(x: self.convertFrame.maxX + self.config.space + self.config.arrowSize.height, y: self.convertFrame.midY - self.config.arrowSize.width/2.0))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.maxX + self.config.space, y: self.convertFrame.midY))
            arrowBezier.addLine(to: CGPoint(x: self.convertFrame.maxX + self.config.space + self.config.arrowSize.height, y: self.convertFrame.midY + self.config.arrowSize.width/2.0))
        default:
            break
        }
        self.config.arrowColor.setFill()
        arrowBezier.fill()
    }
    
}
