//
//  SingleMonthView.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import JTAppleCalendar

class SingleMonthView: MikCalendarView {
    
    required public init(config: Config) {
        super.init(config: config)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - MikCalendarViewProtocols
    override func clear() {
        defer { self.selectedDateChangedHandler?(.single(nil)) }
        self.deselectAllDates()
    }
    
    override func setupSelectedDate(type: MikCalendarSelectedType, isResetAnchor: Bool = false) {
        switch type {
        case .single(let date):
            self.configSelectedDate(date, isResetAnchor: isResetAnchor)
        default: return
        }
    }
    
    // MARK: - JTACMonthViewDelegate, JTACMonthViewDataSource
    override func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: NSStringFromClass(SingleCalendarDayCell.self), for: indexPath) as! SingleCalendarDayCell
        self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        return cell
    }
    
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        super.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
        if cellState.selectionType == .some(.userInitiated) {
            self.selectedDateChangedHandler?(.single(self.selectedDates.first?.mik.endOfDay()))
        }
    }
    
}

// MARK: - Assistant
extension SingleMonthView {
    
    private func configure() {
        self.register(SingleCalendarDayCell.self, forCellWithReuseIdentifier: NSStringFromClass(SingleCalendarDayCell.self))
    }
    
}

// MARK: - Public
extension SingleMonthView {
    
    /// conifg current selelcted date
    /// - Parameter selectedDate: current selelcted date
    /// - Parameter isResetAnchor: whether to reset the anchor point
    func configSelectedDate(_ selectedDate: Date?, isResetAnchor: Bool) {
        defer { self.reloadData(withAnchor: isResetAnchor ? selectedDate : nil)}
        if let selectedDate = selectedDate {
            self.selectDates([selectedDate], triggerSelectionDelegate: true, keepSelectionIfMultiSelectionAllowed: false)
        }else {
            self.deselectAllDates()
        }
    }
    
}
