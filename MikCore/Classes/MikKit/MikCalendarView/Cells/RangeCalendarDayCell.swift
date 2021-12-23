//
//  RangeCalendarDayCell.swift
//  MikCore
//
//  Created by m7 on 2021/4/26.
//

import UIKit
import SnapKit
import JTAppleCalendar


fileprivate let kPanelViewHeight: CGFloat = kCalendarItemSize.height - kCalendarItemSpace

fileprivate extension SelectedPosition {
    
    var selectedColor: UIColor {
        switch self {
        case .start: return UIColor.mik.general(.hexCF1F2E)
        case .end: return UIColor.mik.general(.hex1B1B1B)
        default: return UIColor.clear
        }
    }
    
}

class RangeCalendarDayCell: SingleCalendarDayCell {
    
    override var state: CellState? {
        didSet {
            self.selectedView.isHidden = !(state?.isSelected ?? false)
            self.panelView.isHidden = !(state?.isSelected ?? false)
        
            switch state?.selectedPosition() {
            case .left:
                self.panelView.layer.cornerRadius = kPanelViewHeight * 0.5
                self.panelView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            case .middle:
                self.panelView.layer.cornerRadius = 0
                self.panelView.layer.maskedCorners = []
            case .right:
                self.panelView.layer.cornerRadius = kPanelViewHeight * 0.5
                self.panelView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            case .full:
                self.panelView.layer.cornerRadius = kPanelViewHeight * 0.5
                self.panelView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
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
extension RangeCalendarDayCell {
    
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
extension RangeCalendarDayCell {
    
    func config(state: CellState, selectedPosition: SelectedPosition?) {
        self.state = state
        self.selectedView.backgroundColor = {
            if state.isSelected {
                return selectedPosition?.selectedColor
            }
            return UIColor.mik.general(.hexCF1F2E)
        }()
        
        self.dayLabel.textColor = {
            if state.isSelected {
                switch selectedPosition {
                case .start, .end: return UIColor.mik.text(.hexFFFFFF)
                default: return state.dateBelongsTo == .thisMonth ? UIColor.mik.general(.hex1B1B1B) : UIColor.mik.general(.hexCDCDCD)
                }                
            }else {
                return state.dateBelongsTo == .thisMonth ? UIColor.mik.general(.hex1B1B1B) : UIColor.mik.general(.hexCDCDCD)
            }
        }()
    }
    
}
