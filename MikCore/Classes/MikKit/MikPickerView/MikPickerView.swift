//
//  MikPickerView.swift
//  MikCore
//
//  Created by m7 on 2021/4/28.
//

import UIKit
import SnapKit


public typealias CustomButtonCallback = (_ button: UIButton) -> Void
public typealias SelectedCallbacll = ([IndexPath]) -> Void

open class MikPickerView: UIView {
        
    public var confirmHandler: SelectedCallbacll?
    
    private let title: String?
    private let items: [[MikPickerItem]]!
    private var seledtedIndexPaths = [IndexPath]()
    
    private lazy var titleView: PVTitleView = {
        let aTitleView = PVTitleView()
        aTitleView.confirmButton.addTarget(self, action: #selector(didClickOnConfirmButton(_:)), for: .touchUpInside)
        aTitleView.titleLabel.text = title
        return aTitleView
    }()
    
    private lazy var pickerView: UIPickerView = {
        let aPickerView = UIPickerView()
        aPickerView.backgroundColor = .white
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
    required public init(title: String? = nil, items: [[MikPickerItem]], customConfirm: CustomButtonCallback? = nil) {
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
extension MikPickerView {
    
    private func configure() {
        self.backgroundColor = UIColor.mik.general(.hexFFFFFF)
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
            make.bottom.equalToSuperview().offset(-UIViewController.mik.safeAreaMin.bottom)
            make.height.equalTo(210.rate)
        }
    }
    
}

// MARK: - Private SEL
extension MikPickerView {
    
    @objc private func didClickOnConfirmButton(_ sender: UIButton) {
        self.confirmHandler?(self.seledtedIndexPaths)
    }
    
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate
extension MikPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
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
        aLabel.font = UIFont.mik.font(.nunitoSansBold, size: 16)
        aLabel.textColor = UIColor.mik.text(.hex1B1B1B)
        aLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return aLabel
    }()
    
    private(set) lazy var confirmButton: UIButton = {
        let aBtn = UIButton()
        aBtn.setTitle("Done", for: .normal)
        aBtn.setTitleColor(UIColor.mik.text(.hex0475BC), for: .normal)
        aBtn.setTitleColor(UIColor.mik.text(.hex0475BC).withAlphaComponent(0.5), for: .highlighted)
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
        aView.backgroundColor = UIColor.mik.general(.hexEAEAEA)
        return aView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        addSubview(confirmButton)
        addSubview(separateView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.height.lessThanOrEqualToSuperview()
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
