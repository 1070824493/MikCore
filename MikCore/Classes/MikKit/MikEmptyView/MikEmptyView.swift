//
//  MikEmptyView.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/24.
//

import UIKit
import SnapKit

fileprivate extension MikEmptyValuesConfig.ButtonValues.Style {
    
    var backgroundColor: UIColor {
        switch self {
        case .redFill: return UIColor.mik.general(.hexCF1F2E)
        case .blackFill: return UIColor.mik.general(.hex1B1B1B)
        case .redBorder, .blackBorder: return UIColor.mik.general(.hexFFFFFF)
        case .refresh: return UIColor.clear
        }
    }
    
    var highlightBackgroundColor: UIColor {
        switch self {
        case .redFill: return UIColor.mik.general(.hexEB003B)
        case .blackFill: return UIColor.mik.general(.hex5F5F5F)
        case .redBorder, .blackBorder: return UIColor.mik.general(.hex1B1B1B, alpha: 0.07)
        case .refresh: return UIColor.clear
        }
    }
    
    var borderColor: UIColor? {
        switch self {
        case .redBorder: return UIColor.mik.general(.hexCF1F2E)
        case .blackBorder: return UIColor.mik.general(.hex1B1B1B)
        default: return nil
        }
    }
    
    var titleColor: UIColor {
        switch self {
        case .redFill, .blackFill: return UIColor.mik.text(.hexFFFFFF)
        case .redBorder: return UIColor.mik.text(.hexCF1F2E)
        case .blackBorder: return UIColor.mik.text(.hex1B1B1B)
        case .refresh: return UIColor.mik.text(.hex0475BC)
        }
    }
    
    var highlightTitleColor: UIColor {
        switch self {
        case .redFill: return UIColor.mik.text(.hexFFFFFF)
        case .blackFill: return UIColor.mik.text(.hexFFFFFF)
        case .redBorder: return UIColor.mik.text(.hexEB003B)
        case .blackBorder: return UIColor.mik.text(.hex1B1B1B)
        case .refresh: return UIColor.mik.text(.hex0475BC, alpha: 0.5)
        }
    }
    
}

public struct MikEmptyValuesConfig {
    
    public struct ImageValues {
        public var image: UIImage?
        public var tinColor: UIColor
        
        public init(image: UIImage?, tinColor: UIColor = UIColor.mik.general(.hex1B1B1B)) {
            self.image = image
            self.tinColor = tinColor
        }
    }
    
    public struct TitleValues {
        public var text: String?
        public var font: UIFont
        public var textColor: UIColor
        public var textAlignment: NSTextAlignment
        
        public init(text: String?, font: UIFont = UIFont.mik.font(.nunitoSansBold, size: 16), textColor: UIColor = UIColor.mik.text(.hex1B1B1B), textAlignment: NSTextAlignment = .center) {
            self.text = text
            self.font = font
            self.textColor = textColor
            self.textAlignment = textAlignment
        }
    }
    
    public struct MessageValues {
        public var text: String?
        public var font: UIFont
        public var textColor: UIColor
        public var textAlignment: NSTextAlignment
        
        public init(text: String?, font: UIFont = UIFont.mik.font(size: 12), textColor: UIColor = UIColor.mik.text(.hex757575), textAlignment: NSTextAlignment = .center) {
            self.text = text
            self.font = font
            self.textColor = textColor
            self.textAlignment = textAlignment
        }
    }
    
    public struct ButtonValues {
        public enum Style {
            case redFill, redBorder, blackFill, blackBorder, refresh
        }
        
        public var title: String?
        public var style: Style
        
        public init(title: String?, style: Style = .redFill) {
            self.title = title
            self.style = style
        }
     }
    
    public init() {}
    
    /// 背景颜色
    public var backgroundColor = UIColor.mik.general(.hexFFFFFF)
    /// 全视图点击事件
    public var tapHandler: (() -> Void)?
    /// 图片配置项
    public var imageValues: ImageValues?
    /// 标题配置项
    public var titleValues: TitleValues?
    /// 描述配置项
    public var messageValues: MessageValues?
    /// 事件按钮配置项
    public var buttonValues: ButtonValues?

}

public class MikEmptyView: UIView {
    
    public typealias CustomActionButtonCallback = (UIButton) -> Void
    public typealias ActionHandler = () -> Void
    
    private let valuesConfig: MikEmptyValuesConfig
    private let offsetCenterY: CGFloat?
    private let handler: ActionHandler?

    private lazy var iconImgView: MEImageView = {
        let aImageView = MEImageView()
        aImageView.tintColor = valuesConfig.imageValues?.tinColor
        aImageView.imgView.image = valuesConfig.imageValues?.image
        return aImageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.numberOfLines = 0
        aLabel.font = valuesConfig.titleValues?.font
        aLabel.textColor = valuesConfig.titleValues?.textColor
        aLabel.textAlignment = valuesConfig.titleValues?.textAlignment ?? .center
        aLabel.text = valuesConfig.titleValues?.text
        return aLabel
    }()
    
    private lazy var messageLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.numberOfLines = 0
        aLabel.font = valuesConfig.messageValues?.font
        aLabel.textColor = valuesConfig.messageValues?.textColor
        aLabel.textAlignment = valuesConfig.messageValues?.textAlignment ?? .center
        aLabel.text = valuesConfig.messageValues?.text
        return aLabel
    }()
    
    private lazy var actionButtonView: MEButtonView = {
        let aBtnView = MEButtonView()
        aBtnView.actionBtn.addTarget(self, action: #selector(didClickOnActionButton(_:)), for: .touchUpInside)
        if let style = valuesConfig.buttonValues?.style {
            if style == .refresh {
                aBtnView.actionBtn.setAttributedTitle({
                    guard let title = valuesConfig.buttonValues?.title else { return nil }
                    return NSAttributedString(string: title, attributes: [.foregroundColor: style.titleColor, .underlineStyle: 1])
                }(), for: .normal)
                
                aBtnView.actionBtn.setAttributedTitle({
                    guard let title = valuesConfig.buttonValues?.title else { return nil }
                    return NSAttributedString(string: title, attributes: [.foregroundColor: style.highlightTitleColor, .underlineStyle: 1])
                }(), for: .highlighted)
            }else {
                aBtnView.actionBtn.setTitle(valuesConfig.buttonValues?.title, for: .normal)
                aBtnView.actionBtn.setTitleColor(style.titleColor, for: .normal)
                aBtnView.actionBtn.setTitleColor(style.highlightTitleColor, for: .highlighted)
            }
            aBtnView.actionBtn.setBackgroundImage(UIImage.mik.image(style.backgroundColor), for: .normal)
            aBtnView.actionBtn.setBackgroundImage(UIImage.mik.image(style.highlightBackgroundColor), for: .highlighted)
                        
            if let borderColor = style.borderColor {
                aBtnView.actionBtn.layer.borderColor = borderColor.cgColor
                aBtnView.actionBtn.layer.borderWidth = 2
            }
        }
        return aBtnView
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView(arrangedSubviews: {
            var subViews = [UIView]()
            if let _ = valuesConfig.imageValues?.image { subViews.append(iconImgView) }
            if let _ = valuesConfig.titleValues?.text { subViews.append(titleLabel) }
            if let _ = valuesConfig.messageValues?.text { subViews.append(messageLabel) }
            if let _ = valuesConfig.buttonValues?.title { subViews.append(actionButtonView) }
            return subViews
        }())
        aStackView.axis = .vertical
        aStackView.alignment = .fill
        aStackView.spacing = 10
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    public required init(valuesConfig: MikEmptyValuesConfig, offsetCenterY: CGFloat? = nil, handler: ActionHandler? = nil) {
        self.valuesConfig = valuesConfig
        self.offsetCenterY = offsetCenterY
        self.handler = handler
        
        super.init(frame: .zero)
        
        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    override init(frame: CGRect) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        self.valuesConfig.tapHandler?()
    }
    
}

// MARK: - Assistant
extension MikEmptyView {
    
    private func configure() {
        backgroundColor = valuesConfig.backgroundColor
    }
    
    private func setupSubviews() {
        addSubview(mStackView)
    }
    
    private func setupSubviewsConstraints() {
        mStackView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(offsetCenterY ?? 0)
            make.width.equalToSuperview().multipliedBy(0.87)
        }
    }
    
}

// MARK: - Private
extension MikEmptyView {
    
    @objc
    private func didClickOnActionButton(_ sender: UIButton) {
        self.handler?()
    }
    
}

// MARK: - Hit test
extension MikEmptyView {
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard valuesConfig.tapHandler == nil else {
            return super.hitTest(point, with: event)
        }
        
        guard let view = super.hitTest(point, with: event), view is UIButton else {
            return nil
        }
        return view
    }
    
}


// MARK: - MEImageView
class MEImageView: UIView {
    
    private(set) lazy var imgView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.top.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(14)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - MEButton
class MEButtonView: UIView {    
    
    private(set) lazy var actionBtn: UIButton = {
        let aBtn = UIButton()
        aBtn.titleLabel?.font = UIFont.mik.font(.nunitoSansBold, size: 14)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 16, left: 24, bottom: 16, right: 24)
        aBtn.layer.cornerRadius = 25
        aBtn.layer.masksToBounds = true
        return aBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(actionBtn)
        
        actionBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0))
            make.height.equalTo(50)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
