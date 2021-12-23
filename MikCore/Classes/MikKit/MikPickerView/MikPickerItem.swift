//
//  MikPickerItem.swift
//  MikCore
//
//  Created by m7 on 2021/4/28.
//

import UIKit

public struct MikPickerItem {
    
    private(set) var title: String?
    private(set) var font: UIFont
    private(set) var color: UIColor
    private(set) var isSelected: Bool
    
    public init(title: String, font: UIFont = UIFont.mik.font(.nunitoSansBold, size: 20), color: UIColor = UIColor.mik.text(.hex1B1B1B), isSelected: Bool = false) {
        self.title = title
        self.font = font
        self.color = color
        self.isSelected = isSelected
    }
    
}
