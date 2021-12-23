//
//  Michaels.extras.swift
//  MikCore
//
//  Created by m7 on 2021/4/23.
//

import Foundation

public func MikPrint(file: String = #file,
                     line: Int = #line,
                     _ item: Any...) {
//    #if DEBUG
    let time: String = {
        let dfm = DateFormatter()
        dfm.dateFormat = "HH:mm:ss.sss"
        return dfm.string(from: Date())
    }()
    
    let filename: String = {
        let fileArr = file.components(separatedBy: ["/", "."])
        guard !fileArr.isEmpty else { return "" }
        if fileArr.indices ~= fileArr.endIndex - 2 {
            return fileArr[fileArr.endIndex - 2]
        }
        return fileArr[0]
    }()
    
    print("\(time) \(filename) (\(line)): ", item.map({ String(describing: $0) }).joined(separator: " "))
//    #endif
}
