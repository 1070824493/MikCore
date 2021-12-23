//
//  ClassSingleMonthView.swift
//  MikCore
//
//  Created by m7 on 2021/11/26.
//

import UIKit
import JTAppleCalendar

class ClassSingleMonthView: MikCalendarView {
    
    private var dotCounts: [DotCountsTuple]? {
        didSet {
            self.reloadData()
        }
    }
    
    required public init(config: Config) {
        super.init(config: config)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func handleConfiguration(cell: JTACDayCell?, cellState: CellState, date: Date, classesCount: Int) {
        (cell as? ClassSingleCalendarDayCell)?.classesCount = classesCount
        self.handleConfiguration(cell: cell, cellState: cellState, date: date)
    }
    
    // MARK: - MikCalendarViewProtocols
    override func clear() {
        defer { self.selectedDateChangedHandler?(.single(nil)) }
        self.deselectAllDates()
    }
    
    override func setupDotCounts(_ dotCounts: [DotCountsTuple]?) {
        self.dotCounts = dotCounts
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
        func dotCount(date: Date) -> Int {
            return self.dotCounts?.first(where: { $0.date.mik.isInSameDay(date: date) })?.count ?? 0
        }
        
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: NSStringFromClass(ClassSingleCalendarDayCell.self), for: indexPath) as! ClassSingleCalendarDayCell
        self.handleConfiguration(cell: cell, cellState: cellState, date: date, classesCount: dotCount(date: date))
        return cell
    }
    
    override func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        let inRange = super.calendar(calendar, shouldSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
        return inRange && cellState.dateBelongsTo == .thisMonth
    }
    
    override func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        super.calendar(calendar, didSelectDate: date, cell: cell, cellState: cellState, indexPath: indexPath)
        if cellState.selectionType == .some(.userInitiated) {
            self.selectedDateChangedHandler?(.single(self.selectedDates.first?.mik.endOfDay()))
        }
    }
    
}

// MARK: - Assistant
extension ClassSingleMonthView {
    
    private func configure() {
        self.register(ClassSingleCalendarDayCell.self, forCellWithReuseIdentifier: NSStringFromClass(ClassSingleCalendarDayCell.self))
    }
    
}

// MARK: - Public
extension ClassSingleMonthView {
    
    /// conifg current selelcted date
    /// - Parameter selectedDate: current selelcted date
    /// - Parameter isResetAnchor: whether to reset the anchor point
    func configSelectedDate(_ selectedDate: Date?, isResetAnchor: Bool) {
        defer { self.reloadData(withAnchor: isResetAnchor ? selectedDate : nil)}
        if let selectedDate = selectedDate {
            self.selectDates([selectedDate], triggerSelectionDelegate: false, keepSelectionIfMultiSelectionAllowed: false)
        }else {
            self.deselectAllDates()
        }
    }
    
}
