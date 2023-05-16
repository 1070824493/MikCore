//
//  NetworkTestUtils.swift
//  MikCore_Example
//
//  Created by m7 on 2022/4/27.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import Foundation
import Alamofire
import HandyJSON
import MikCore


fileprivate let token = "eyJhbGciOiJIUzUxMiJ9.eyJjbGllbnRJZCI6InVzciIsIl91c2VySWQiOiI4MTAzNDAxNzQ1MjY1MDEiLCJfc2VsbGVyU3RvcmVJZCI6bnVsbCwiX2RldmljZVV1aWQiOiJFRURDOTM4Qi0zNDBELTQwQjktQjk0Qi1BQkVBMDI0OTk4RkEiLCJfZGV2aWNlTmFtZSI6IlNpbXVsYXRvciIsIl9jcmVhdGVUaW1lIjoiMTY1MTAzMDQ5NzIzNCIsIl9leHBpcmVUaW1lIjoiMTY1MzYyMjQ5NzIzNCIsInN1YiI6IjgxMDM0MDE3NDUyNjUwMSIsImlhdCI6MTY1MTAzMDQ5NywiZXhwIjoxNjUzNjIyNDk3LCJhdWQiOiJ1c2VyIiwianRpIjoiYUhIWjdrZG51NXNMQVVPU0Z3ajZqSDh3NzhWelhSejcifQ.Mq8RkmzQhzvQc_YZ6gRcVIQIQGT2L9j60u0ECdBsMPuvgMmoWieyrxYQtBRUoFK7ETbT4pYC1JqYKrZowpms6g"

public let businessSuccessCode = ["200", "1", "Success"]

public extension HTTPHeaders {
    
    static let mikDefault = HTTPHeaders([.contentTypeJSON(),
                                         .authorization(bearerToken: token)])
    
}

public extension MikStandardModel {
    var isSuccess: Bool {
        if let code = code {
            return businessSuccessCode.contains(code)
        }else{
            return false
        }
    }
}
