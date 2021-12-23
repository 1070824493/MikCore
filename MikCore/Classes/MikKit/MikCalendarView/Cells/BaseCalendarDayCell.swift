//
//  BaseCalendarDayCell.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit
import JTAppleCalendar

class BaseCalendarDayCell: JTACDayCell {
    
    public var state: CellState? {
        didSet {
            self.dayLabel.text = state?.text
            self.dayLabel.textColor = state?.dateBelongsTo == .thisMonth ? UIColor.mik.general(.hex1B1B1B) : UIColor.mik.general(.hexCDCDCD)
            
            self.todaySignView.isHidden = {
                if let state = state {
                    return !Calendar.current.isDateInToday(state.date)
                }
                return true
            }()
        }
    }
    
    private var isToday: Bool = false {
        didSet {
            self.todaySignView.isHidden = !isToday
        }
    }
    
    private(set) lazy var dayLabel: UILabel = {
        let aLabel = UILabel()
        aLabel.font = UIFont.mik.font(.nunitoSans, size: 14)
        aLabel.textAlignment = .center
        return aLabel
    }()
    
    private(set) lazy var todaySignView: UIView = {
        let aView = UIView()
        aView.isUserInteractionEnabled = false
        aView.backgroundColor = UIColor.mik.general(.hexCF1F2E)
        return aView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(dayLabel)
        contentView.bringSubviewToFront(todaySignView)
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
extension BaseCalendarDayCell {
    
    private func setupSubviews() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(todaySignView)
    }
    
    private func setupSubviewsConstraints() {
        dayLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        todaySignView.snp.makeConstraints { (make) in
            make.width.equalTo(18)
            make.height.equalTo(2)
            make.bottom.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
        }
    }
    
}
