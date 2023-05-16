//
//  String.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/5.
//

import Foundation
import UIKit

// MARK: - Utils
public extension MikNameSpace where Base == String {
    
    /// 是否包含 Emoji 表情
    var isContainsEmoji: Bool {
        for scalar in self.base.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            // fix bug：九宫格拼音
//            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F018...0x1F270, // Various asian characters
            0x238C...0x2454, // Misc items
            0x20D0...0x20FF: // Combining Diacritical Marks for Symbols
            return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 转换为数值类型
    var numberValue: NSNumber? { NumberFormatter.mik.numberValue(self.base) }
        
    /// 计算高度
    func boundingRect(font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        let attContent = NSMutableAttributedString(string: self.base, attributes: att)
        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
    
    /// 随机字符串
    /// - Parameter timestamp: 时间戳
    /// - Returns: 根据时间戳生成的8位长度的16进制字符串
    static func randomByTimestamp(_ timestamp: TimeInterval = Date().timeIntervalSince1970) -> String {
        let time16Text = "00000000" + String(Int(timestamp * 1000000 + Double(arc4random()) / 1000000), radix: 16)
        return String(time16Text.suffix(8))
    }
    
}

// MARK: - URL Encoding
public extension MikNameSpace where Base == String {
    
    /// URL编码
    func urlEncoding(_ chars: [String]? = nil) -> String? {
        return self.base.addingPercentEncoding(withAllowedCharacters: {
            guard let chars = chars, !chars.isEmpty else { return .urlQueryAllowed }
            var charSet: CharacterSet = .urlQueryAllowed
            chars.forEach({ charSet.insert(charactersIn: $0) })
            return charSet
        }())
    }

    /// URL编码
    func afUrlEncoding() -> String? {
        return self.base.addingPercentEncoding(withAllowedCharacters: .afURLQueryAllowed)
    }
    
}

// MARK: - Indices
public extension MikNameSpace where Base == String {
    
    /// 取下标处元素
    subscript(i: Int) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: i)
        let endIndex = self.base.index(startIndex, offsetBy: 1)
        return String(self.base[startIndex ..< endIndex])
    }
    
    /// 使用下标截取字符串
    /// eg: "abcdef".mik[3 ..< 5] 可得 "de"
    subscript(r: Range<Int>) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: r.lowerBound)
        let endIndex = self.base.index(self.base.startIndex, offsetBy: r.upperBound)
        return String(self.base[startIndex ..< endIndex])
    }
    
    /// 使用下标截取字符串
    /// eg: "abcdef".mik[3, 2] 可得 "de"
    subscript(index: Int, length: Int) -> String {
        let startIndex = self.base.index(self.base.startIndex, offsetBy: index)
        let endIndex = self.base.index(startIndex, offsetBy: length)
        return String(self.base[startIndex ..< endIndex])
    }
    
    
    /// 从起始位置截取对应长度的子串
    /// - Parameter to: 子串结束位置
    func substring(to: Int) -> String { self.base.mik[0 ..< to] }
    
    /// 从指定位置截取到结束位置的子串
    /// - Parameter from: 子串起始位置
    func substring(from: Int) -> String { self.base.mik[from ..< self.base.count] }
    
}

// MARK: - Formatter
public extension MikNameSpace where Base == String {
    
    /// 格式化字符串
    /// - Parameters:
    ///   - splitLenths: 格式化规则
    ///   - separator: 给定位置插入的字符
    /// - Returns: 给定规则格式化后的字符串
    /// - Note: 例如："1234567890".mik.formatter(splitLenths: [3, 3, 4], separator: "-") -> "123-456-7890"
    func formatter(splitLenths: [Int], separator: Character) -> String {
        guard !splitLenths.isEmpty, !splitLenths.isEmpty else { return self.base }
                
        var bString = self.base.split(separator: separator).joined()
        
        var insertIndex = 0
        for i in (0 ..< Int.max) {
            insertIndex += min(splitLenths[min(i, splitLenths.count - 1)], Int.max - insertIndex)
            if insertIndex >= bString.count { break }
            
            bString.insert(separator, at: bString.index(bString.startIndex, offsetBy: insertIndex))
            insertIndex += String(separator).count
        }
        
        return bString
    }
    
}


public extension MikNameSpace where Base == String {
    
    func capitalized() -> String {
        let uppercases = [ "ok" ]
        
        // 首字母不大写的虚词 (非首尾位置)
        let filters = [ "a", "an", "at", "the", "this", "my", "our", "his", "her", "its", "all", "and", "but", "for", "or", "so", "as", "in", "up", "of", "off", "on", "by", "to" ]
        if uppercases.contains(self.base.lowercased()) {
            return self.base.uppercased()
        } else {
            let array = self.base.components(separatedBy: " ")
            var items = [String]()
            for (index, item) in array.enumerated() {
                if filters.contains(item.lowercased()) && index != 0 && index != (array.count - 1) {
                    items.append(item.lowercased())
                } else {
                    items.append(item.capitalized)
                }
            }
            return items.joined(separator: " ")
        }
    }
    
}
