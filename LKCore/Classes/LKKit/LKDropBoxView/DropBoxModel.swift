//
//  DropBoxModel.swift
//  LKCore
//
//  Created by gaowei on 2021/4/26.
//

import UIKit

public class DropBoxModel: NSObject {
    public var title: String?
    
    public var isSelected: Bool = false
    
    public var isHiddenSelected: Bool = false
    public var titleFont: UIFont = UIFont.lk.font(size: 14.rate)
    public var titleColor: UIColor = UIColor.lk.text(.hex1B1B1B)
}
