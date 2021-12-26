//
//  HTTPManager+RxSwift.swift
//  MikCore
//
//  Created by ty on 2021/11/29.
//

import Foundation
import HandyJSON
import RxSwift
import SwiftyJSON

public protocol RequestModelCallback {
    associatedtype M

    func onResult(response: MikStandardModel<M>?)

    func onError(e: Error)
}

public protocol RequestJSONCallback {
    

    func onResult(response: JSON?)

    func onError(e: Error)
}



extension HTTPManager {
    static func request<T: HandyJSON, R: RequestModelCallback>(type: T.Type, config: HTTPRequestConfig, callback: R) where R.M == T {
        HTTPManager.requestModel(type: T.self, config: config) { root, error in
            if let e = error {
                callback.onError(e: e)
            } else {
                callback.onResult(response: root)
            }
        }
    }
    
    static func request<R: RequestJSONCallback>(config: HTTPRequestConfig, callback: R) {
        HTTPManager.requestSwiftyJSON(config: config) { json, error in
            if let e = error {
                callback.onError(e: e)
            } else {
                callback.onResult(response: json)
            }
        }
    }
}

class RequestJSONCallbackResponse {

    let subject: PublishSubject<JSON>

    init(subject: PublishSubject<JSON>) {
        self.subject = subject
    }

}

class RequestModelCallbackResponse<T: HandyJSON> {

    let subject: PublishSubject<MikStandardModel<T>>

    init(subject: PublishSubject<MikStandardModel<T>>) {
        self.subject = subject
    }

}

extension RequestModelCallbackResponse : RequestModelCallback {
    
    public typealias M = T
    
    public func onResult(response: MikStandardModel<M>?) {
        if let response = response {
            self.subject.onNext(response)
        }
        self.subject.onCompleted()
    }

    public func onError(e: Error) {
        self.subject.onError(e)
    }
}
 

extension RequestJSONCallbackResponse : RequestJSONCallback {

    func onResult(response: JSON?) {
        self.subject.onNext(response ?? JSON())
        self.subject.onCompleted()
    }
    
    func onError(e: Error) {
        self.subject.onError(e)
    }
}
