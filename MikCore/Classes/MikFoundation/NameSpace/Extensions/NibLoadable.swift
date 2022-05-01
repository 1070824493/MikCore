//
//  NibLoadable.swift
//  MikCore
//
//  Created by ty on 2022/5/1.
//

import Foundation

public extension MikNameSpace where Base: UIView {
    static var nib: UINib {
        return UINib(nibName: className(), bundle: Bundle(for: Base.self))
    }

    static func loadFromNib(_ index: Int = 0) -> Base? {
        return nib.instantiate(withOwner: nil, options: nil)[index] as? Base
    }
}

public extension MikNameSpace where Base: UIViewController {
    static func loadFromNib() -> Base {
        return Base(nibName: className(), bundle: Bundle(for: Base.self))
    }
}
