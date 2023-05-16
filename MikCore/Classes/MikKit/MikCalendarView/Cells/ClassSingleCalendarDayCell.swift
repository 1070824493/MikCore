//
//  ClassSingleCalendarDayCell.swift
//  MikCore
//
//  Created by m7 on 2021/4/25.
//

import UIKit
import SnapKit
import JTAppleCalendar

fileprivate let kSelectedViewHeight: CGFloat = 32.rate

class ClassSingleCalendarDayCell: BaseCalendarDayCell {
    
    override var state: CellState? {
        didSet {            
            self.contentView.alpha = {
                guard let state = state, state.dateBelongsTo == .thisMonth else { return 0.5 }
                return 1
            }()
            
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
            self.todaySignView.isHidden = true
        }
    }
    
    var classesCount: Int = 0 {
        didSet {
            self.dotsView.dotCount = classesCount
        }
    }
            
    private(set) lazy var selectedView: UIView = {
        let aView = UIView()
        aView.isUserInteractionEnabled = false
        aView.backgroundColor = UIColor.mik.general(.hexCF1F2E)
        aView.layer.cornerRadius = 12
        return aView
    }()
    
    private lazy var dotsView: CSCDotsView = CSCDotsView()
    
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
extension ClassSingleCalendarDayCell {
    
    private func setupSubviews() {
        contentView.addSubview(selectedView)
        contentView.addSubview(dotsView)
    }
    
    private func setupSubviewsConstraints() {
        selectedView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(kSelectedViewHeight)
        }
        
        dotsView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
    }
    
}


// MARK: - CSCDotView
class CSCDotsView: UIView {
    
    class DotView: UIView {
        override var intrinsicContentSize: CGSize { CGSize(width: 4, height: 4) }
    }
    
    var dotCount: Int = 0 {
        didSet {
            guard dotCount != oldValue else { return }
            self.mStackView.mik.removeAllArrangedSubviewsCompletely()
            self.mStackView.mik.addArrangedSubviewsCompletely(Array(self.dotViews.prefix(dotCount)))
        }
    }
    
    private lazy var dotViews: [UIView] = {
        var subViews: [UIView] = (0...2).map({ _ in createDotView() })
        subViews.append(UIImageView(image: UIImage.image("mik_calendar_plus")))
        return subViews
    }()
    
    private lazy var mStackView: UIStackView = {
        let aStackView = UIStackView()
        aStackView.axis = .horizontal
        aStackView.alignment = .center
        aStackView.spacing = 3
        aStackView.distribution = .equalSpacing
        return aStackView
    }()
    
    private func createDotView() -> UIView {
        let aView = DotView()
        aView.backgroundColor = UIColor.mik.general(.hex0475BC)
        aView.layer.cornerRadius = 2
        aView.layer.masksToBounds = true
        return aView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(mStackView)
        
        mStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
