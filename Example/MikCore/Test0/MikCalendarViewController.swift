//
//  MikCalendarViewController.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit

class MikCalendarViewController: MikBaseViewController {

    private let style: MikCalendarStyle
    
    private lazy var monthView: MikCalendarView = {
        let aMouthView = MikCalendarView.calendarMouthView(style: style)
        aMouthView.scrollToDate(Date(), animateScroll: false)
        aMouthView.visibleDateChangedHandler = { visibleDates in
            if let date = visibleDates.monthDates.last?.date ?? visibleDates.outdates.last?.date {
                print("visibleDates.last: \(date)")
            }
        }
        aMouthView.selectedDateChangedHandler = { style in
            switch style {
            case .single(let date):
                print("已选时间为：\(String(describing: date))")
            case .range(let dateRange):
                print("已选时间为：from: \(String(describing: dateRange?.fromDate)), to: \(String(describing: dateRange?.toDate))")
            }
        }
        aMouthView.gobackMonthEnableHandler = { [weak self] isEnable in
            self?.gobackMonthBtn.isEnabled = isEnable
        }
        aMouthView.forwordMonthEnableHandler = { [weak self] isEnable in
            self?.forwardMonthBtn.isEnabled = isEnable
        }
        return aMouthView
    }()
    
    private lazy var gobackMonthBtn: UIButton = self.createActionButton(title: "上个月", selector: #selector(gobackMonth(_:)))
    
    private lazy var forwardMonthBtn: UIButton = self.createActionButton(title: "下个月", selector: #selector(forwardMonth(_:)))
    
    private lazy var todayBtn: UIButton = self.createActionButton(title: "回到今天并选中", selector: #selector(gobackToToday(_:)))
    
    private lazy var exchangedStyleBtn: UIButton = self.createActionButton(title: "显示折叠样式", selector: #selector(exchangedDisplayStyle(_:)))
    
    
    private func createActionButton(title: String, selector: Selector) -> UIButton {
        let aBtn = UIButton()
        aBtn.setTitle(title, for: .normal)
        aBtn.addTarget(self, action: selector, for: .touchUpInside)
        aBtn.backgroundColor = .lightGray
        aBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
        aBtn.setTitleColor(UIColor.purple, for: .normal)
        aBtn.setTitleColor(UIColor.purple.withAlphaComponent(0.5), for: .disabled)
        return aBtn
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(didClickOnClearBarButton(_:)))

        // Do any additional setup after loading the view.
        view.addSubview(monthView)
        view.addSubview(gobackMonthBtn)
        view.addSubview(forwardMonthBtn)
        view.addSubview(todayBtn)
        view.addSubview(exchangedStyleBtn)
        
        monthView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(Self.mik.safeAreaMax.top + 20)
            make.centerX.equalToSuperview()
        }
        
        gobackMonthBtn.snp.makeConstraints { make in
            make.top.equalTo(monthView.snp.bottom).offset(40)
            make.centerX.equalTo(monthView).multipliedBy(0.5)
        }
        
        forwardMonthBtn.snp.makeConstraints { make in
            make.top.equalTo(monthView.snp.bottom).offset(40)
            make.centerX.equalTo(monthView).multipliedBy(1.5)
        }
        
        todayBtn.snp.makeConstraints { make in
            make.top.equalTo(gobackMonthBtn.snp.bottom).offset(24)
            make.centerX.equalTo(monthView).multipliedBy(0.5)
        }
        
        exchangedStyleBtn.snp.makeConstraints { make in
            make.top.equalTo(forwardMonthBtn.snp.bottom).offset(24)
            make.centerX.equalTo(monthView).multipliedBy(1.5)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 设置标记，当‘style == singleForClass’时生效
        monthView.setupDotCounts((0...40).map({ (Date().mik.dateOffset(day: $0) ?? Date(), Int.random(in: 0...5)) }))
    }
    
    required init(style: MikCalendarStyle) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func didClickOnClearBarButton(_ sender: UIBarButtonItem) {
        self.monthView.clear()
    }
    
    @objc
    private func gobackMonth(_ sender: UIButton) {
        self.monthView.gobackMonth()
    }
        
    @objc
    private func forwardMonth(_ sender: UIButton) {
        self.monthView.forwardMonth()
    }
    
    @objc
    private func gobackToToday(_ sender: UIButton) {
        switch style {
        case .single(_), .singleForClass(_):
            monthView.setupSelectedDate(type: .single(Date()), isResetAnchor: true)        
        case .range(_):
            monthView.setupSelectedDate(type: .range((Calendar.current.date(byAdding: .day, value: -5, to: Date())!, Date())), isResetAnchor: true)
        case .limit(_, _):
            monthView.setupSelectedDate(type: .limit(Date()), isResetAnchor: true)
        }
    }
    
    @objc
    private func exchangedDisplayStyle(_ sender: UIButton) {
        monthView.setupFolding(true)
    }
    
}
