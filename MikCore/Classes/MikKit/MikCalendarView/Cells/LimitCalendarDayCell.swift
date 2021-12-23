//
//  LimitCalendarDayCell.swift
//  MikCore
//
//  Created by m7 on 2021/4/27.
//

import UIKit
import SnapKit
import JTAppleCalendar

fileprivate let kPanelViewHeight: CGFloat = kCalendarItemSize.height - kCalendarItemSpace

class LimitCalendarDayCell: SingleCalendarDayCell {        
    
    private var limitPosition: LimitPosition = .none {
        didSet {
            self.panelView.isHidden = limitPosition == .none
        
            switch limitPosition {
            case .left:
                self.panelView.layer.cornerRadius = kPanelViewHeight * 0.5
                self.panelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                self.panelView.layer.cornerRadius = 0
                self.panelView.layer.maskedCorners = []
            case .right:
                self.panelView.layer.cornerRadius = kPanelViewHeight * 0.5
                self.panelView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            default: break
            }
        }
    }
    
    private lazy var panelView: UIView = {
        let aView = UIView()
        aView.backgroundColor = UIColor.mik.general(.hexEAEAEA)
        aView.isUserInteractionEnabled = false
        return aView
    }()
    
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
extension LimitCalendarDayCell {
    
    private func setupSubviews() {
        contentView.addSubview(panelView)
    }
    
    private func setupSubviewsConstraints() {
        panelView.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.centerY.equalTo(selectedView)
        }
    }
    
}

// MARK: - Public
extension LimitCalendarDayCell {
    
    func config(state: CellState, limitDateRange: MikDateRangeTuple) {
        self.state = state
        self.limitPosition = LimitPosition.position(dateRange: limitDateRange, date: state.date)
    }
    
}
