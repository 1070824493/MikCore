//
//  NumberFormatter.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/13.
//

import Foundation


fileprivate extension LKNameSpace where Base == NumberFormatter {
    
    static let numberFormatter: NumberFormatter = {
        let aNumberFormatter = NumberFormatter()
        aNumberFormatter.locale = Locale(identifier: "en_US")
        return aNumberFormatter
    }()
    
}

public extension LKNameSpace where Base == NumberFormatter {
        
    /// 字符串转 NSNumber
    /// - Parameter numberText: 数值字符串    
    static func numberValue(_ numberText: String?) -> NSNumber? {
        guard let numberText = numberText else { return nil }
        Self.numberFormatter.numberStyle = .decimal
        return Self.numberFormatter.number(from: numberText)
    }
    
}

public extension BinaryFloatingPoint {
    
    typealias UnitTuple = (value: Self, unit: String?)
    typealias FractionDigitsTuple = (min: Int, max: Int)
    
    /// 数值转换
    /// - Returns: 转换后的值和单位
    func converUnit() -> UnitTuple {
        switch abs(self) {
        case 1000 ..< 1000000: return (self / 1000, "K")
        case 1000000 ..< 100000000: return (self / 1000000, "M")
        case 100000000 ..< Self.infinity: return (self / 100000000, "B")
        default: return (self, nil)
        }
    }
    
    /// "距离"单位
    /// - Returns: 表示"距离"的单位
    func converDistanceUnit() -> String {
        switch abs(self) {
        case 0 ... 1: return "mile"
        default: return "miles"
        }
    }
    
    /// 小数位位数转换
    /// - Parameters:
    ///   - originMin: 原小数位下限
    ///   - originMax: 原小数位上限
    /// - Returns: 小数位位数
    func converFractionDigits(originMin: Int, originMax: Int) -> FractionDigitsTuple {
        switch (abs(self), Double(Int(self)) == Double(self)) {
        case (0 ..< 1000, true): return (0, 0)
        default: return (originMin, originMax)
        }
    }
        
    
    /// 数值格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的数值样式，eg: xxx.xx  + "K/M/B"
    func asUnitNumber(minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        let unitTuple = self.converUnit()
        let fractionDigitsTuple = self.converFractionDigits(originMin: minimumFractionDigits, originMax: maximumFractionDigits)
        
        NumberFormatter.lk.numberFormatter.numberStyle = .decimal
        NumberFormatter.lk.numberFormatter.roundingMode = .halfUp
        NumberFormatter.lk.numberFormatter.minimumFractionDigits = fractionDigitsTuple.min
        NumberFormatter.lk.numberFormatter.maximumFractionDigits = fractionDigitsTuple.max
        let value = NumberFormatter.lk.numberFormatter.string(for: NSDecimalNumber(string: "\(unitTuple.value)"))
        return [value, unitTuple.unit].compactMap({ $0 }).joined()
    }
    
    /// 货币格式化, 不带单位
    /// - Parameters:
    ///   - currencyCode: 货币代码
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的货币样式，eg: $xxx.xx
    func asCurrencyNumber(currencyCode: String = "USD", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        NumberFormatter.lk.numberFormatter.numberStyle = .currency
        NumberFormatter.lk.numberFormatter.currencyCode = currencyCode
        NumberFormatter.lk.numberFormatter.roundingMode = .halfUp
        NumberFormatter.lk.numberFormatter.minimumFractionDigits = minimumFractionDigits
        NumberFormatter.lk.numberFormatter.maximumFractionDigits = maximumFractionDigits
        return NumberFormatter.lk.numberFormatter.string(for: NSDecimalNumber(string: "\(self)"))
    }

    
    /// 货币格式化
    /// - Parameters:
    ///   - currencyCode: 货币代码
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的货币样式，eg: $xxx.xx  + "K/M/B"
    func asCurrencyUnitNumber(currencyCode: String = "USD", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        let unitTuple = self.converUnit()
        let value = unitTuple.value.asCurrencyNumber(currencyCode: currencyCode, maximumFractionDigits: maximumFractionDigits)
        return [value, unitTuple.unit].compactMap({ $0 }).joined()
    }
    
    /// 距离格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的距离样式， xxx.x + "mile/miles"
    func asDistanceNumber(minimumFractionDigits: Int = 1, maximumFractionDigits: Int = 1) -> String? {
        let distanceUnit: String = self.converDistanceUnit()
        NumberFormatter.lk.numberFormatter.numberStyle = .decimal
        NumberFormatter.lk.numberFormatter.roundingMode = .halfUp
        NumberFormatter.lk.numberFormatter.minimumFractionDigits = minimumFractionDigits
        NumberFormatter.lk.numberFormatter.maximumFractionDigits = maximumFractionDigits
        let value = NumberFormatter.lk.numberFormatter.string(for: NSDecimalNumber(string: "\(self)"))
        return [value, distanceUnit].compactMap({ $0 }).joined(separator: " ")
    }
    
    /// 距离格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的距离样式， xxx.x + "K/M/B" + "mile/miles"
    func asDistanceUnitNumber(minimumFractionDigits: Int = 1, maximumFractionDigits: Int = 1) -> String? {
        guard let unitNumber = self.asUnitNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits) else {
            return nil
        }
        
        let distanceUnit: String = self.converDistanceUnit()
        return [unitNumber, distanceUnit].joined(separator: " ")
    }
    
}

public extension BinaryInteger {
    
    /// 数值格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的数值样式，eg: xxx.xx + "K/M/B"
    func asUnitNumber(minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        return Double(self).asUnitNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 货币格式化, 不带单位
    /// - Parameters:
    ///   - currencyCode: 货币代码
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的货币样式，eg: $xxx.xx
    func asCurrencyNumber(currencyCode: String = "USD", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        return Double(self).asCurrencyNumber(currencyCode: currencyCode, minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 货币格式化, 值+单位
    /// - Parameters:
    ///   - currencyCode: 货币代码
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的货币样式，eg: $xxx.xx + "K/M/B"
    func asCurrencyUnitNumber(currencyCode: String = "USD", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        return Double(self).asCurrencyUnitNumber(currencyCode: currencyCode, minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 距离格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的距离样式， xxx.x + "mile/miles"
    func asDistanceNumber(minimumFractionDigits: Int = 1, maximumFractionDigits: Int = 1) -> String? {
        return Double(self).asDistanceNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 距离格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的距离样式，eg: xxx.x + "mile/miles"
    func asDistanceUnitNumber(minimumFractionDigits: Int = 1, maximumFractionDigits: Int = 1) -> String? {
        return Double(self).asDistanceUnitNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
}

public extension String {
    
    /// 数值格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的数值样式，eg: xxx.xx + "K/M/B"
    func asUnitNumber(minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        return Double(self)?.asUnitNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 货币格式化, 不带单位
    /// - Parameters:
    ///   - currencyCode: 货币代码
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的货币样式，eg: $xxx.xx
    func asCurrencyNumber(currencyCode: String = "USD", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        return Double(self)?.asCurrencyNumber(currencyCode: currencyCode, minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 货币格式化, 值+单位
    /// - Parameters:
    ///   - currencyCode: 货币代码
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的货币样式，eg: $xxx.xx + "K/M/B"
    func asCurrencyUnitNumber(currencyCode: String = "USD", minimumFractionDigits: Int = 2, maximumFractionDigits: Int = 2) -> String? {
        return Double(self)?.asCurrencyUnitNumber(currencyCode: currencyCode, minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 距离格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的距离样式， xxx.x + "mile/miles"
    func asDistanceNumber(minimumFractionDigits: Int = 1, maximumFractionDigits: Int = 1) -> String? {
        return Double(self)?.asDistanceNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
    /// 距离格式化
    /// - Parameters:
    ///   - minimumFractionDigits: 小数位下限
    ///   - maximumFractionDigits: 小数位上限
    /// - Returns: 格式化后的距离样式，eg: xxx.x + "mile/miles"
    func asDistanceUnitNumber(minimumFractionDigits: Int = 1, maximumFractionDigits: Int = 1) -> String? {
        return Double(self)?.asDistanceUnitNumber(minimumFractionDigits: minimumFractionDigits, maximumFractionDigits: maximumFractionDigits)
    }
    
}
