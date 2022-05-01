//
//  MikInterceptor.swift
//  MikCore
//
//  Created by ty on 2022/4/22.
//

import Alamofire
import Foundation

public class RetryInterceptor: RequestInterceptor {

    public var target: HTTPTarget?

    public init(target: HTTPTarget? = nil) {
        self.target = target
    }

    public func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard let target = target else {
            completion(.doNotRetry)
            return
        }

        switch target.retry {
        case .never:
            completion(.doNotRetry)
        case .foreverUntilSuccess(let delay):
            completion(.retryWithDelay(delay))
        case .severalTimes(let times, let delay):
            if request.retryCount >= times {
                completion(.doNotRetryWithError(error))
            } else {
                completion(.retryWithDelay(delay))
            }
        }
    }
}
