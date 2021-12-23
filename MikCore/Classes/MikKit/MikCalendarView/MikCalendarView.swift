//
//  MikCalendarView.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import JTAppleCalendar

public typealias DotCountsTuple = (date: Date, count: Int)

public protocol MikCalendarViewProtocols {
    
    /// 清除当前选中项
    func clear()
    
    /// 回到今天
    func gobackToday()
    
    /// 上个月
    func gobackMonth()
    
    /// 下个月
    func forwardMonth()
        
    /// 设置当前选中时间
    /// - Parameters:
    ///   - type: 当前选中时间样式
    ///   - isResetAnchor: 是否重置锚点，'ture'时将滚蛋到当前选中位置
    func setupSelectedDate(type: MikCalendarSelectedType, isResetAnchor: Bool)
        
    /// 设置是否折叠
    /// - Parameter isFolding: 是否折叠
    /// - Returns: 操作是否执行成功
    @discardableResult
    func setupFolding(_ isFolding: Bool) -> Bool
    
    /// 设置底部远点标记
    /// - Parameter dotCounts: 远点标记
    func setupDotCounts(_ dotCounts: [DotCountsTuple]?)
    
}


public extension MikCalendarView {
    
    static func calendarMouthView(style: MikCalendarStyle, dateRange: MikDateRangeTuple? = nil, isFolding: Bool = false) -> MikCalendarView {
        switch style {
        case .single(let date):
            let singleMouthView = SingleMonthView(config: Config(dateRange: dateRange ?? Date.defaultDateRange(), isFolding: isFolding))
            singleMouthView.configSelectedDate(date, isResetAnchor: true)
            return singleMouthView
            
        case .singleForClass(let date):
            let classSingleMouthView = ClassSingleMonthView(config: Config(dateRange: dateRange ?? Date.defaultDateRange(), isFolding: isFolding))
            classSingleMouthView.configSelectedDate(date, isResetAnchor: true)
            return classSingleMouthView
            
        case .range(let bDateRange):
            let multiplMouthView = RangeMouthView(config: Config(dateRange: dateRange ?? Date.defaultDateRange(), isFolding: isFolding))
            multiplMouthView.configSelectedDateRange(fromDate: bDateRange?.fromDate, endDate: bDateRange?.toDate)
            return multiplMouthView
            
        case .limit(let bDateRange, let date):
            let limitMouthView = LimitMouthView(limitDateRange: bDateRange, dateRange: dateRange)
            limitMouthView.configSelectedDate(date, isResetAnchor: true)
            return limitMouthView
        }
    }
    
}


public class MikCalendarView: JTACMonthView, JTACMonthViewDelegate, JTACMonthViewDataSource, MikCalendarViewProtocols {
    
    public struct Config {
        /// 日期范围，决定能显示的日期的范围
        var dateRange: MikDateRangeTuple = Date.defaultDateRange()
        /// 是否折叠
        var isFolding: Bool = false
        /// 每页显示行数
        var numberOfRows: Int { self.isFolding ? 1 : 6 }
        
        mutating func setFolding(_ isFolding: Bool) {
            self.isFolding = isFolding
        }
    }
    
    /// 显示时间段变更回调
    public var visibleDateChangedHandler: ((DateSegmentInfo) -> Void)?
    
    /// 日期选择变更回调
    public var selectedDateChangedHandler: MikCalendarSelectedChangedCallback?
    
    /// 是否还能切换到上个月回调
    public var gobackMonthEnableHandler: ((Bool) -> Void)?
    
    /// 是否还能切换到下个月回调
    public var forwordMonthEnableHandler: ((Bool) -> Void)?
    
    /// 配置
    private var config: Config
    
    open override var intrinsicContentSize: CGSize {
        CGSize(width: kCalendarItemSize.width * CGFloat(kCalendarDayOfWeek),
               height: kCalendarItemSize.height * CGFloat(self.config.numberOfRows))
    }
    
    public func handleConfiguration(cell: JTACDayCell?, cellState: CellState,date: Date) {
        (cell as? BaseCalendarDayCell)?.state = cellState
    }
    
    /// 指定初始化器
    /// - Parameter config: 相关配置参数
    required public init(config: Config) {
        self.config = config
        
        super.init()
        configure()
    }

    
    private override init() {
        fatalError("init() has not been implemented")
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - MikCalendarViewProtocols
    public func clear() {}
    
    public func gobackToday() {}
    
    public func gobackMonth() {
        let visibleDates = self.visibleDates()
        
        guard let currentAnchorDate = visibleDates.monthDates.last?.date ?? visibleDates.outdates.last?.date else { return }
        
        guard let newAnchorDate = currentAnchorDate.mik.dateOffset(month: -1)?.mik.startOfMonth() else { return }
        
        guard self.config.dateRange.fromDate.distance(to: newAnchorDate) >= 0 else {
            // 超出日历显示范围
            return
        }
        
        self.scrollToDate(newAnchorDate)
    }
        
    public func forwardMonth() {
        let visibleDates = self.visibleDates()
        
        guard let currentAnchorDate = visibleDates.monthDates.last?.date ?? visibleDates.outdates.last?.date else { return }
        
        guard let newAnchorDate = currentAnchorDate.mik.dateOffset(month: 1)?.mik.startOfMonth() else { return }
        
        guard newAnchorDate.distance(to: self.config.dateRange.toDate) >= 0 else {
            // 超出日历显示范围
            return
        }
        
        self.scrollToDate(newAnchorDate)
    }
                
    public func setupSelectedDate(type: MikCalendarSelectedType, isResetAnchor: Bool) {}
    
    public func setupDotCounts(_ dotCounts: [DotCountsTuple]?) {}
    
    public func setupFolding(_ isFolding: Bool) -> Bool {
        // 滚动过程中此操作将取不到‘anchorDate’，所以用户触摸、拖拽、滚动时将不执行操作
        guard self.config.isFolding != isFolding,
                !(self.isTracking || self.isDragging || self.isDecelerating) else { return false }
        
        let anchorDate: Date? = {
            if let selectDate = self.selectedDates.first {
                return selectDate
            }
            return self.visibleDates().monthDates.first?.date
        }()
        
        defer {
            self.reloadData(withAnchor: anchorDate) { [weak self] in
                guard let visibleDates = self?.visibleDates() else { return }
                self?.visibleDateChangedHandler?(visibleDates)
            }
        }
                
        self.invalidateIntrinsicContentSize()
        self.config.setFolding(isFolding)
        
        return true
    }
            
    
    // MARK: - JTACMonthViewDelegate, JTACMonthViewDataSource
    public func calendar(_ calendar: JTACMonthView, willDisplay cell: JTACDayCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        self.handleConfiguration(cell: cell, cellState: cellState, date: date)
    }

    public func calendar(_ calendar: JTACMonthView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTACDayCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: NSStringFromClass(BaseCalendarDayCell.self), for: indexPath) as! BaseCalendarDayCell        
        self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        return cell
    }

    public func calendar(_ calendar: JTACMonthView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        self.visibleDateChangedHandler?(visibleDates)
        self.gobackMonthEnableHandler?(isGobackMonth())
        self.forwordMonthEnableHandler?(isForwardMonth())
    }

    public func calendar(_ calendar: JTACMonthView, didSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) {
            self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        }
    }

    public func calendar(_ calendar: JTACMonthView, didDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) {
        if cellState.selectionType == .some(.userInitiated) {
            self.handleConfiguration(cell: cell, cellState: cellState, date: date)
        }
    }

    public func configureCalendar(_ calendar: JTACMonthView) -> ConfigurationParameters {
        return ConfigurationParameters(startDate: self.config.dateRange.fromDate,
                                       endDate: self.config.dateRange.toDate,
                                       numberOfRows: self.config.numberOfRows,
                                       generateInDates: .forAllMonths,
                                       generateOutDates: .tillEndOfGrid,
                                       firstDayOfWeek: .monday)
    }
    
    public func calendar(_ calendar: JTACMonthView, shouldSelectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return LimitPosition.position(dateRange: self.config.dateRange, date: date) != .none
    }
    
    public func calendar(_ calendar: JTACMonthView, shouldDeselectDate date: Date, cell: JTACDayCell?, cellState: CellState, indexPath: IndexPath) -> Bool {
        return true
    }
    
}

// MARK: - Assistant
extension MikCalendarView {
    
    private func configure() {
        backgroundColor = UIColor.mik.general(.hexFFFFFF)
        calendarDelegate = self
        calendarDataSource = self
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        allowsRangedSelection = true
        allowsMultipleSelection = false
        showsHorizontalScrollIndicator = false
        scrollDirection = .horizontal
        scrollingMode = .stopAtEachCalendarFrame
        register(BaseCalendarDayCell.self, forCellWithReuseIdentifier: NSStringFromClass(BaseCalendarDayCell.self))
    }
    
}

// MARK: - Private
extension MikCalendarView {
    
    /// 是否还能切换到上个月
    private func isGobackMonth() -> Bool {
        let visibleDates = self.visibleDates()
        
        guard let currentAnchorDate = visibleDates.monthDates.last?.date ?? visibleDates.outdates.last?.date else { return false }
        
        guard let newAnchorDate = currentAnchorDate.mik.dateOffset(month: -1)?.mik.startOfMonth() else { return false }
        
        return self.config.dateRange.fromDate.distance(to: newAnchorDate) >= 0
    }
    
    
    /// 是否还能切换到下个月
    private func isForwardMonth() -> Bool {
        let visibleDates = self.visibleDates()
        
        guard let currentAnchorDate = visibleDates.monthDates.last?.date ?? visibleDates.outdates.last?.date else { return false }
        
        guard let newAnchorDate = currentAnchorDate.mik.dateOffset(month: 1)?.mik.startOfMonth() else { return false }
        
        return newAnchorDate.distance(to: self.config.dateRange.toDate) >= 0
    }
    
}
