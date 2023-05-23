//
//  LKPickerView.swift
//  LKCore
//
//  Created by m7 on 2021/4/28.
//

import UIKit
import SnapKit


public typealias CustomButtonCallback = (_ button: UIButton) -> Void
public typealias CloseCallbacll = () -> Void
public typealias SelectedCallbacll = ([IndexPath]) -> Void

open class LKPickerView: UIView {
        
    public var closeHandler: CloseCallbacll?
    public var confirmHandler: SelectedCallbacll?
    
    private let title: String?
    private let items: [[LKPickerItem]]!
    private var seledtedIndexPaths = [IndexPath]()
    
    private lazy var titleView: PVTitleView = {
        let aTitleView = PVTitleView()
        aTitleView.closeButton.addTarget(self, action: #selector(didClickOnCloseButton(_:)), for: .touchUpInside)
        aTitleView.confirmButton.addTarget(self, action: #selector(didClickOnConfirmButton(_:)), for: .touchUpInside)
        aTitleView.titleLabel.text = title
        return aTitleView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let aPickerView = UIPickerView()
        aPickerView.backgroundColor = UIColor.lk.color(.hexF6F6F6)
        aPickerView.dataSource = self
        aPickerView.delegate = self
        seledtedIndexPaths.forEach({ aPickerView.selectRow($0.row, inComponent: $0.section, animated: false) })
        return aPickerView
    }()
    
    /// 初始化
    /// - Parameters:
    ///   - title: 标题
    ///   - items: 选项集
    ///   - customConfirm: 自定义确认按钮
    required public init(title: String? = nil, items: [[LKPickerItem]], customConfirm: CustomButtonCallback? = nil) {
        self.title = title
        self.items = items
        
        super.init(frame: .zero)
        
        for (section, ims) in items.enumerated() {
            var idp = IndexPath(row: 0, section: section)
            if let selectedIdx = ims.firstIndex(where: { $0.isSelected }) {
                idp = IndexPath(row: selectedIdx, section: section)
            }
            seledtedIndexPaths.append(idp)
        }
                
        customConfirm?(titleView.confirmButton)

        configure()
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
    
}

// MARK: - Assistant
extension LKPickerView {
    
    private func configure() {
        backgroundColor = UIColor.lk.color(.hexF6F6F6)
    }
    
    private func setupSubviews() {
        addSubview(titleView)
        addSubview(pickerView)
    }
    
    private func setupSubviewsConstraints() {
        titleView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: UIScreen.main.bounds.width, height: 52))
        }
        
        pickerView.snp.makeConstraints { (make) in
            make.top.equalTo(titleView.snp.bottom)
            make.width.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-UIViewController.lk.safeAreaMin.bottom)
            make.height.equalTo(210.rate)
        }
    }
    
}

// MARK: - Private SEL
extension LKPickerView {
    
    @objc
    private func didClickOnCloseButton(_ sender: UIButton) {
        self.closeHandler?()
    }
    
    @objc
    private func didClickOnConfirmButton(_ sender: UIButton) {
        self.confirmHandler?(self.seledtedIndexPaths)
    }
    
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension LKPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.items.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 42
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.items[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        seledtedIndexPaths.removeAll(where: { $0.section == component })
        self.seledtedIndexPaths.append(IndexPath(row: row, section: component))
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let item = self.items[component][row]
        
        // 修改分割线
        pickerView.subviews.forEach({ $0.isHidden = $0.bounds.height <= 1.0 })
        
        let titleLabel = view as? UILabel ?? UILabel()
        titleLabel.textAlignment = .center
        titleLabel.font = item.font
        titleLabel.textColor = item.color
        titleLabel.text = item.title
        
        return titleLabel
    }
}


// MARK: - PVTitleView
class PVTitleView: UIView {
    
    private(set) lazy var titleLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.lk.font(.nunitoSansBold, size: 16)
        aLabel.textColor = UIColor.lk.text(.hex1B1B1B)
        aLabel.textAlignment = .center
        aLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return aLabel
    }()
    
    private(set) lazy var closeButton: UIButton = {
        let aBtn = UIButton()
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 16)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        aBtn.setImage(UIImage.image("nav_del"), for: .normal)
        aBtn.setContentCompressionResistancePriority(.required, for: .horizontal)
        aBtn.setContentCompressionResistancePriority(.required, for: .vertical)
        aBtn.setContentHuggingPriority(.required, for: .horizontal)
        aBtn.setContentHuggingPriority(.required, for: .vertical)
        return aBtn
    }()
    
    private(set) lazy var confirmButton: UIButton = {
        let aBtn = UIButton()
        aBtn.titleLabel?.font = UIFont.lk.font(.nunitoSansBold, size: 16)
        aBtn.setTitle("Done", for: .normal)
        aBtn.setTitleColor(UIColor.lk.text(.hex0475BC), for: .normal)
        aBtn.setTitleColor(UIColor.lk.text(.hex0475BC).withAlphaComponent(0.5), for: .highlighted)
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        aBtn.setContentCompressionResistancePriority(.required, for: .horizontal)
        aBtn.setContentCompressionResistancePriority(.required, for: .vertical)
        aBtn.setContentHuggingPriority(.required, for: .horizontal)
        aBtn.setContentHuggingPriority(.required, for: .vertical)
        return aBtn
    }()
    
    private lazy var separateView: UIView = {
        let aView = UIView()
        aView.isUserInteractionEnabled = false
        aView.backgroundColor = UIColor.lk.color(.hexF6F6F6)
        return aView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.lk.color(.hexFFFFFF)
        
        addSubview(titleLabel)
        addSubview(closeButton)
        addSubview(confirmButton)
        addSubview(separateView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
        }
        
        closeButton.snp.makeConstraints { make in
            make.right.lessThanOrEqualTo(titleLabel.snp.left).offset(-4)
            make.left.height.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(44)
        }
        
        confirmButton.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(titleLabel.snp.right).offset(4)
            make.right.height.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(44)
        }
        
        separateView.snp.makeConstraints { (make) in
            make.bottom.width.centerX.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}