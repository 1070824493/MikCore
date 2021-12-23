//
//  SingleCalendarDayCell.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit
import JTAppleCalendar

fileprivate let kSelectedViewHeight: CGFloat = kCalendarItemSize.height - kCalendarItemSpace

class SingleCalendarDayCell: BaseCalendarDayCell {
    
    override var state: CellState? {
        didSet {
            self.dayLabel.textColor = {
                if state?.isSelected ?? false {
                    return UIColor.mik.text(.hexFFFFFF)
                }else {
                    if state?.dateBelongsTo == .thisMonth {
                        return UIColor.mik.text(.hex1B1B1B)
                    }
                    return UIColor.mik.text(.hexCDCDCD)
                }
            }()
            
            self.selectedView.isHidden = !(state?.isSelected ?? false)
        }
    }
            
    private(set) lazy var selectedView: UIView = {
        let aView = UIView()
        aView.isUserInteractionEnabled = false
        aView.backgroundColor = UIColor.mik.general(.hexCF1F2E)
        aView.layer.cornerRadius = kSelectedViewHeight * 0.5
        return aView
    }()
    
    override func layoutSubviews() {
        defer { super.layoutSubviews() }
        contentView.bringSubviewToFront(selectedView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
        setupSubviewsConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Assistant
extension SingleCalendarDayCell {
    
    private func setupSubviews() {
        contentView.addSubview(selectedView)
    }
    
    private func setupSubviewsConstraints() {
        selectedView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(kSelectedViewHeight)
        }
    }
    
}
