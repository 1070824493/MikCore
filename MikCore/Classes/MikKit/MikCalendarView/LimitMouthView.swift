//
//  LimitMouthView.swift
//  MikCore
//
//  Created by m7 on 2021/4/27.
//

import UIKit
import JTAppleCalendar

class LimitMouthView: MikCalendarView {
        
    private let limitDateRange: MikDateRangeTuple
    
    override func handleConfiguration(cell: JTACDayCell?, cellState: CellState, date: Date) {
        (cell as? LimitCalendarDayCell)?.config(state: cellState, limitDateRange: self.limitDateRange)
    }
    
    required public init(limitDateRange: MikDateRangeTuple, config: Config) {
        self.limitDateRange = limitDateRange
        
        super.init(config: config)
        configure()
    }
    
    convenience init(limitDateRange: MikDateRangeTuple, dateRange: MikDateRangeTuple? = nil) {
        self.init(limitDateRange: limitDateRange, config: MikCalendarView.Config(dateRange: dateRange ?? Date.defaultDateRange(), isFolding: false))
    }
    
    internal required init(dateRange: MikDateRangeTuple? = nil) {
        fatalError()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required public init(config: Config) {
        fatalError("init(config:) has not been implemented")
    }
    
    // MARK: - MikCalendarViewProtocols
    override func clear() {
        defer { self.selectedDateChangedHandler?(.single(nil)) }
        self.deselectAllDates()
    }
    
    override func setupSelectedDate(type: MikCalendarSelectedType, isResetAnchor: Bool) {
        switch type {
        case .limit(let date):
            self.configSelectedDate(date, isResetAnchor: isResetAnchor)
        default: return
        }
    }
    
    // MARK: - JTACMonthViewDelegate, JTACMonthViewDataSource
    override func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: NSStringFromClass(LimitCalendarDayCell.self), for: indexPath) as! LimitCalendarDayCell
        self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        return cell
    }
    
    override func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return LimitPosition.position(dateRange: self.limitDateRange, date: date) != .none
    }
    
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        super.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
        if cellState.selectionType == .some(.userInitiated) {
            self.selectedDateChangedHandler?(.single(self.selectedDates.first?.mik.endOfDay()))
        }
    }
    
}

// MARK: - Assistant
extension LimitMouthView {
    
    private func configure() {
        self.register(LimitCalendarDayCell.self, forCellWithReuseIdentifier: NSStringFromClass(LimitCalendarDayCell.self))
    }
    
}

// MARK: - Public
extension LimitMouthView {
    
    /// conifg current selelcted date
    /// - Parameter selectedDate: current selelcted date
    /// - Parameter isResetAnchor: whether to reset the anchor point 
    func configSelectedDate(_ selectedDate: Date?, isResetAnchor: Bool) {
        defer { self.reloadData(withAnchor: isResetAnchor ? selectedDate : nil) }
        if let selectedDate = selectedDate {
            self.selectDates([selectedDate], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
        }else {
            self.deselectAllDates()
        }
    }
    
}
