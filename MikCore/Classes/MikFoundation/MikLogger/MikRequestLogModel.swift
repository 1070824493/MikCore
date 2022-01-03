//
//  MikRequestLogModel.swift
//  MikCore
//
//  Created by ty on 2021/12/29.
//

import Foundation
import HandyJSON

public struct MikRequestLogModel: HandyJSON {
    public init() {}

    public var url: String?
    public var method: String?
    public var params: [String: Any]?
    public var requestHeader: [String: Any]?
    public var responseHeader: [String: Any]?
    public var requestTime: TimeInterval? {
        didSet {
            if let requestTime = self.requestTime {
                self.requestTimeStr = MikLogger.logAPITimeFormatter.string(from: Date(timeIntervalSince1970: requestTime))
            }
        }
    }

    public var responseTime: TimeInterval? {
        didSet {
            if let responseTime = self.responseTime {
                self.responseTimeStr = MikLogger.logAPITimeFormatter.string(from: Date(timeIntervalSince1970: responseTime))
            }
        }
    }

    public var requestTimeStr: String?
    public var responseTimeStr: String?

    public var requestDuration: TimeInterval?
    public var email: String?
    public var response: String?
    public var errorDescription: String?
    public var httpCode: Int?
    public var isSuccess: Bool = false

}


public struct MikLogConfig {
    public var email : String?
    public var fcmToken : String?

    public init(email: String? = nil, fcmToken: String? = nil) {
        self.email = email
        self.fcmToken = fcmToken
    }
}
