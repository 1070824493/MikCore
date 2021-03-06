//
//  RangeMouthView.swift
//  MikCore
//
//  Created by m7 on 2021/4/26.
//

import UIKit
import JTAppleCalendar

fileprivate enum UserEditType {
    case start, end    
}

class RangeMouthView: MikCalendarView {
    
    private var selectedRange: MikDateRangeTuple? {
        didSet {
            defer { self.reloadData() }
            self.deselectAllDates(triggerSelectionDelegate: false)
            if let selectedRange = selectedRange {
                self.selectDates(from: selectedRange.fromDate, to: selectedRange.toDate, triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
            }
        }
    }
    
    private var nextEditType: UserEditType = .start
    
    override func handleConfiguration(cell: JTACDayCell?, cellState: CellState, date: Date) {
        (cell as? RangeCalendarDayCell)?.config(state: cellState, selectedPosition: self.exceedMaxOrMin(date: date))
    }
    
    required public init(config: Config) {
        super.init(config: config)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MikCalendarViewProtocols
    override func clear() {
        defer { self.selectedDateChangedHandler?(.range(nil)) }
        self.selectedRange = nil
    }
    
    override func setupSelectedDate(type: MikCalendarSelectedType, isResetAnchor: Bool = false) {
        switch type {
        case .range(let dateRange):
            self.configSelectedDateRange(fromDate: dateRange?.fromDate, endDate: dateRange?.toDate)
        default: return
        }
    }
    
    // MARK: - JTACMonthViewDelegate, JTACMonthViewDataSource
    override func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: NSStringFromClass(RangeCalendarDayCell.self), for: indexPath) as! RangeCalendarDayCell
        self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        return cell
    }
    
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) {
            self.tapDate(date: date)
        }else {
            self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        }
    }
    
    override func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) {
            self.tapDate(date: date)
        }else {
            self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        }
    }
    
}

// MARK: - Assistant
extension RangeMouthView {
    
    private func configure() {
        self.allowsMultipleSelection = true
        self.register(RangeCalendarDayCell.self, forCellWithReuseIdentifier: NSStringFromClass(RangeCalendarDayCell.self))
    }
    
}

// MARK: - Private
extension RangeMouthView {
    
    /// ??????????????????????????????????????????
    /// - Parameter date: ??????????????????
    /// - Returns: ??????????????????????????????
    private func exceedMaxOrMin(date: Date) -> SelectedPosition {
        guard let startDate = self.selectedRange?.fromDate.mik.exactDate(), let endDate = self.selectedRange?.toDate.mik.exactDate(), let bDate = date.mik.exactDate() else {
            return .unknow
        }
        
        switch startDate.compare(bDate) {
        case .orderedDescending: return .left
        case .orderedSame: return .start
        case .orderedAscending:
            switch endDate.compare(bDate) {
            case .orderedDescending: return .middle
            case .orderedSame: return .end
            case .orderedAscending: return .right
            }
        }
    }
    
    private func tapDate(date: Date?) {
        guard let date = date else { return }
        
        defer {
            self.reloadData()
            
            let range: MikDateRangeTuple? = {
                guard let selectedRange = self.selectedRange else { return nil }
                return (selectedRange.fromDate.mik.startOfDay(), selectedRange.toDate.mik.endOfDay())
            }()
            self.selectedDateChangedHandler?(.range(range))
        }
        
        let position = self.exceedMaxOrMin(date: date)
        
        switch position {
        case .unknow:
            // ??????????????????
            self.selectedRange = (date, self.selectedRange?.toDate ?? date)
            self.nextEditType = .end
            return
        case .left:
            // ??????????????????
            self.selectedRange = (date, self.selectedRange?.toDate ?? date)
            self.nextEditType = .start
        case .right:
            // ??????????????????
            self.selectedRange = (self.selectedRange?.fromDate ?? date, date)
            self.nextEditType = .end
            return
        case .start:
            // ??????????????????
            self.nextEditType = .start
            if let selectedRange = self.selectedRange {
                self.selectedRange = (selectedRange.fromDate, selectedRange.toDate)
            }
            return
        case .end:
            // ??????????????????
            self.nextEditType = .end
            if let selectedRange = self.selectedRange {
                self.selectedRange = (selectedRange.fromDate, selectedRange.toDate)
            }
            return
        default: break
        }
        
        switch self.nextEditType {
        case .start:
            self.selectedRange = (date, self.selectedRange?.toDate ?? date)
        case .end:
            self.selectedRange = (self.selectedRange?.fromDate ?? date, date)
        }
    }
    
}

// MARK: - Public
extension RangeMouthView {
    
    /// Config selected date range
    /// - Parameters:
    ///   - fromDate: start date
    ///   - endDate: end date
    func configSelectedDateRange(fromDate: Date?, endDate: Date?) {
        guard let bFromDate = fromDate ?? endDate, let bEndDate = endDate ?? fromDate else {
            self.nextEditType = .start
            return
        }
        
        self.nextEditType = .end
        self.selectedRange = (bFromDate, bEndDate)
    }
    
}

