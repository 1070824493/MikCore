//
//  MikNetworkReachabilityManager.swift
//  MikCore
//
//  Created by m7 on 2021/7/2.
//

import Foundation
import Alamofire
import RxCocoa

public typealias MikNetworkStatus = NetworkReachabilityManager.NetworkReachabilityStatus

public class MikNetworkReachabilityManager {
    
    /// 当前网络状态
    public var status: MikNetworkStatus { NetworkReachabilityManager.default?.status ?? .unknown }
    
    /// 当前网络是否可达
    public var isReachable: Bool { NetworkReachabilityManager.default?.isReachable ?? false }
        
    /// 网络当前是否通过蜂窝接口可达
    public var isReachableOnCellular: Bool { NetworkReachabilityManager.default?.isReachableOnCellular ?? false }
    
    /// 网络当前是否通过以太网或WiFi接口可达
    public var isReachableOnEthernetOrWiFi: Bool { NetworkReachabilityManager.default?.isReachableOnCellular ?? false }
    
    /// 网络状态变化序列
    public let rx_status: PublishRelay<MikNetworkStatus> = PublishRelay()
    
    private init(){}
    public static let shared = MikNetworkReachabilityManager()
    
}

// MARK: - Public
extension MikNetworkReachabilityManager {
        
    /// 开启监听网络状态
    public func startListening() {
        NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { (status) in
            self.rx_status.accept(status)
        })
    }
    
    /// 停止监听网络状态
    public func stopListening() {
        NetworkReachabilityManager.default?.stopListening()
    }
    
}
