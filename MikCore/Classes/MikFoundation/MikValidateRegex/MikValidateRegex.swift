//
//  MikValidateRegex.swift
//  SellerMobile
//
//  Created by m7 on 2021/4/7.
//

import Foundation
 
public enum MikValidateRegex {
        
    case nickname(String)
    case firstName(String)
    case lastName(String)
    case bankName(String)
    case businessName(String)
    
    case email(String)
    case URL(String)
    case usaPhoneNum(String)
    case IP(String)
    /// 纯数字
    case isNumber(String)
    /// 中文数字英文符号
    case isLegal(_: String)
    /// 字母
    case isLetter(String)
    /// 自定义正则
    case custom(text: String, regular: String)
    
}

public extension MikValidateRegex {
    
    private typealias ValuesTuple = (text: String, regular: String)
    
    var isRight: Bool {
        let valuesTuple: ValuesTuple
        
        switch self {
        case .email(let str):
            valuesTuple = (str, "^\\S+@\\S+\\.\\S{2,}$")
            
        case .nickname(let str):
            valuesTuple = (str, "(^[a-zA-Z][a-zA-Z\\s]{0,20}[a-zA-Z]$)")
            
        case .firstName(let str),
             .lastName(let str),
             .businessName(let str):
            valuesTuple = (str, "^([a-zA-Z]+\\s?)*[a-zA-Z]+$")
        
        case .bankName(let str):
            valuesTuple = (str, "^(\\S+\\s?)*\\S+$")
            
        case .URL(let str):
//            let regular = "^(((ht|f)tps?):\\/\\/)?[\\w-]+(\\.[\\w-]+)+([\\w.,@?^=%&:/~+#-]*[\\w@?^=%&/~+#-])?$"
            let regular = "^((http[s]?:\\/\\/(www\\.)?|ftp:\\/\\/(www\\.))?|www\\.){1}([0-9A-Za-z-\\.@:%_\\+~#=]+)+((\\.[a-zA-Z]{2,7})+)(\\/(.)*)?(\\?(.)*)?"
            valuesTuple = (str, regular)

        case .usaPhoneNum(let str):
            valuesTuple = (str, "^([2-9]{1}\\d{9})$")
            
        case .IP(let str):
            let regular = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
            valuesTuple = (str, regular)
            
        case .isNumber(let str):
            valuesTuple = (str, "^[0-9]*$")
            
        case let .isLegal(str):
            valuesTuple = (str, "^[\\p{Han}\\p{P}\\p{L}\\p{N}➋➌➍➎➏➐➑➒￥^+=|~$<>]*$")
            
        case let .isLetter(str):
            valuesTuple = (str, "^[A-Za-z]*$")
            
        case .custom(let text, let regular):
            valuesTuple = (text, regular)
        }
                                
        return NSPredicate(format: "SELF MATCHES %@", valuesTuple.regular).evaluate(with: valuesTuple.text)
    }
    
}
