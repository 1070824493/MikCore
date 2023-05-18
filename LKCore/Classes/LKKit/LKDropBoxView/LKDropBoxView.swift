//
//  LKDropBoxView.swift
//  LKCore
//
//  Created by gaowei on 2021/4/25.
//

import UIKit
import SnapKit

public class LKDropBoxView: UIView {

    /// 选中某一项后的处理闭包
    public var takeDropBoxSelected: ((Int, DropBoxModel) -> Void)?
    
    /// 选项数量
    public var dataArray: [DropBoxModel]? {
        didSet {
            self.tableView.reloadData()
        }
    }
    /// 每一个选项的高度，默认44.0
    public var itemHeight: CGFloat = 44.0 {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    /// 最大下拉高度(不包括输入框)，超过此高度需要滑动，默认没有限制
    public var maxHeight: CGFloat = CGFloat(Int.max)

    /// 下拉动画时间
    public var duration: TimeInterval = 0.3
    
    public var leftTitle: String? {
        get {
            return self.leftLabel.text
        }
        set {
            self.leftLabel.text = newValue
        }
    }
    public var leftTitleColor: UIColor? {
        didSet {
            self.leftLabel.textColor = leftTitleColor
        }
    }
    
    public var leftTitleFont: UIFont? {
        didSet {
            self.leftLabel.font = leftTitleFont
        }
    }
    
    public var rightTitle: String? {
        get {
            return self.rightLabel.text
        }
        set {
            self.rightLabel.text = newValue
        }
    }
    
    public var tableBackgroundColor: UIColor? {
        didSet {
            self.tableView.backgroundColor = tableBackgroundColor
        }
    }
    
    public var currentBounds: CGRect {
        get {
            return CGRect.init(x: 0, y: 0, width: self.tableView.frame.maxX, height: self.tableView.frame.maxY)
        }
    }
    
    private var leftLabel: UILabel = {
        let item = UILabel()
        item.font = UIFont.lk.font(.nunitoSansBold, size: 30.rate)
        item.textColor = UIColor.lk.text(.hex1B1B1B)
        
        return item
    }()
    private var rightLabel: UILabel = {
        let item = UILabel()
        item.font = UIFont.lk.font(.nunitoSansBold, size: 14.rate)
        item.textColor = UIColor.lk.text(.hex1B1B1B)
        
        return item
    }()
    private var rightImageView: UIImageView = {
        let item = UIImageView.init(image: UIImage.image("drop_box_down"))
        return item
    }()
    
    private var isDrop: Bool = false {
        didSet {
            if (isDrop) {
                UIView.animate(withDuration: duration) { [weak self] () in
                    let transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi))
                    self?.rightImageView.transform = transform
                }
                
                self.dropBoxDwon()
            } else {
                UIView.animate(withDuration: duration) { [weak self] () in
                    let transform = CGAffineTransform.init(rotationAngle: CGFloat(0))
                    self?.rightImageView.transform = transform
                }
                
                self.dropBoxUp()
            }
        }
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.lk.general(.hexF6F6F6)
        tableView.register(DropBoxViewCell.self, forCellReuseIdentifier: DropBoxViewCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit();
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        backgroundColor = .clear;
        
        self.addSubview(self.leftLabel)
        self.leftLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(24.rate)
            make.centerY.equalToSuperview()
        }
        
        self.addSubview(self.rightImageView)
        self.rightImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(23.rate)
            make.centerY.equalToSuperview()
        }
        self.addSubview(self.rightLabel)
        self.rightLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightImageView.snp.left).offset(-10.rate)
            make.centerY.equalToSuperview()
        }
        
        let clickeBtn = UIButton.init(type: .custom)
        clickeBtn.addTarget(self, action: #selector(valueBtnAction(btn:)), for: UIControl.Event.touchUpInside)
        self.addSubview(clickeBtn)
        clickeBtn.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        self.addSubview(self.tableView)
    }
    
    @objc private func valueBtnAction(btn: UIButton) {
        isDrop = !isDrop
    }
    
    private func dropBoxDwon() {
        
        var rect: CGRect = self.tableView.frame
        rect.origin.y = self.bounds.height
        rect.size.width = self.bounds.width
        rect.size.height = 0.0
        self.tableView.frame = rect
        
        UIView.animate(withDuration: duration, animations: { [weak self] in
            guard let strongSelf = self else { return }
            
            var h = CGFloat(strongSelf.dataArray?.count ?? 0) * strongSelf.itemHeight + 24.rate
            if( h > strongSelf.maxHeight) {
                strongSelf.tableView.isScrollEnabled = true
                h = strongSelf.maxHeight
            } else {
                strongSelf.tableView.isScrollEnabled = false
            }
            
            strongSelf.tableView.frame.size.height = h
            
            strongSelf.tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: strongSelf.bounds.width, height: 12.rate))
            let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: strongSelf.bounds.width, height: 12.rate))
            let imageView = UIImageView.init(image: UIImage.image("drop_box_shadow"))
            imageView.frame = CGRect.init(x: 0, y: 12.rate - 8.0, width: strongSelf.bounds.width, height: 8.0)
            footerView.addSubview(imageView)
            strongSelf.tableView.tableFooterView = footerView
        })
        
        /// Always at the front
        superview?.bringSubviewToFront(self)
    }
    
    private func dropBoxUp() {
        UIView.animate(withDuration: duration / 2, animations: { [weak self] in
            guard let strongSelf = self else { return }
        
            strongSelf.tableView.frame.size.height = 0.0
            
            strongSelf.tableView.tableHeaderView = UIView()
            strongSelf.tableView.tableFooterView = UIView()
        })
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let toPoint: CGPoint = self.convert(point, to: self.tableView)
        if self.tableView.bounds.contains(toPoint) {
            return self.tableView;
        } else {
            if !self.bounds.contains(point), self.isDrop {
                self.isDrop = false
            }
            return super.hitTest(point, with: event)
        }
        
    }
}

// MARK: - TableView DataSource and Delegate
extension LKDropBoxView: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray?.count ?? 0
    }
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DropBoxViewCell.description(), for: indexPath) as! DropBoxViewCell
        
        if self.dataArray?.count ?? 0 > 0 {
            cell.setModel(self.dataArray![indexPath.row])
        }
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true);
        
        if self.dataArray?.count ?? 0 > 0 {
            self.isDrop = false
            
            let model = self.dataArray![indexPath.row]
            if model.isSelected {
                return
            }
            
            self.dataArray?.forEach({ (model) in
                model.isSelected = false
            })
            
            model.isSelected = true
            self.rightLabel.text = model.title
            self.tableView.reloadData()
            self.takeDropBoxSelected?(indexPath.row, model)
        }
    }
}

