//
//  MikLog.swift
//  Module_Foundation
//
//  Created by ty on 2021/7/12.
//

import UIKit
import SwiftyBeaver
import HandyJSON
import SwiftyJSON

public struct MikLogModel : HandyJSON {
    public init() {
    }
    
    public var url : String?
    public var method : String?
    public var params : [String : Any]?
    public var requestHeader : [String : Any]?
    public var responseHeader : [String : Any]?
    public var requestTime : TimeInterval?{
        didSet{
            if let requestTime = self.requestTime {
                self.requestTimeStr = MikLog.logAPITimeFormatter.string(from: Date(timeIntervalSince1970: requestTime))
            }
        }
    }
    public var responseTime : TimeInterval? {
        didSet{
            if let responseTime = self.responseTime{
                self.responseTimeStr = MikLog.logAPITimeFormatter.string(from: Date(timeIntervalSince1970: responseTime))
            }
        }
    }
    
    public var requestTimeStr : String?
    public var responseTimeStr : String?
    
    public var requestDuration : TimeInterval?
    public var email : String?
    public var response : String?
    public var errorDescription : String?
    public var httpCode : Int?
    public var isSuccess : Bool = false
    
    
    
//    mutating public func mapping(mapper: HelpingMapper) {
//        mapper >>> self.requestTime
//        mapper >>> self.responseTime
//    }
}

fileprivate enum AppType : String {
    case buyer = ""
    case seller
    case shopAndScan
    case shopAndScanIpad
    
    var bundleId : String {
        switch self {
        
        case .buyer:
            return MikLog.buyerBundleID
        case .seller:
            return MikLog.sellerBundleID
        case .shopAndScan:
            return MikLog.shopAndScanBundleID
        case .shopAndScanIpad:
            return MikLog.shopAndScanIpadBundleID
        }
    }
    
}

public class MikLog: NSObject {
    
    public static let shared = MikLog()
    
    
    public var email : String?
    
    fileprivate var blackRequestList : [String] = []
    
    //api 耗时
    fileprivate var durationTime : TimeInterval?{
        didSet{
            let format = self.getFormatString()
            console.format = format
            file.format = format
        }
    }
    
    fileprivate var lastUploadLogTime : TimeInterval = 0
    
    fileprivate static let buyerBundleID : String = "com.michaels.MikMobile.BuyerTool"
    fileprivate static let sellerBundleID : String = "com.michaels.sellertool"
    fileprivate static let shopAndScanBundleID : String = "com.michaels.MikMobile.BuyerTool.ShopAndScanAPP"
    fileprivate static let shopAndScanIpadBundleID : String = "com.michaels.shopscanverificationapp"
    
    
    fileprivate let console = ConsoleDestination()  // log to Xcode Console
    fileprivate let file = FileDestination()  // log to file
    
    //ping
    fileprivate var ping : SwiftyPing?
    fileprivate var lastPing : Double = 0
    
    //fps
    fileprivate var displayLink : CADisplayLink!
    fileprivate var lastTime : CFTimeInterval = 0
    fileprivate var count : Int = 0
    
    fileprivate var fpsCallback : ((Double) -> ())?
    fileprivate var pingCallback : ((PingResult?) -> ())?
    
    fileprivate static let swiftyBeaver = SwiftyBeaver.self
    
    fileprivate static let saveLogDays = 7
    
    /// 删除最近n天以外的日志
    fileprivate static func cleanLogFileWeeksAgo() {
        let files = self.getLogFileList()
        
        if files.count > MikLog.saveLogDays {
            for (index,value) in files.enumerated() {
                if index < files.count - MikLog.saveLogDays {
                    let needDeletePath = self.getLogDirPath() + "/" + value
                    do{
                        try FileManager.default.removeItem(atPath: needDeletePath)
                    }catch{
                        
                    }
                }
            }
        }
    }
    
    /// 获取当天日志文件大小
    fileprivate static func getLogFileSize() -> CLongLong{
        
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: self.getLogFilePath())
            if let size = attr[FileAttributeKey.size] as? CLongLong {
                return size
            }else{
                return 0
            }
        } catch  {
            return 0
        }
        
    }
    
    //本地存储的日志文件时间格式/上传到服务器的文件名字
    fileprivate static let logFileNameFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd"
        f.timeZone = TimeZone.current
        return f
    }()
    
    //API调用时间格式
    fileprivate static let logAPITimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd|HH:mm:ss.SSS"
        f.timeZone = TimeZone.current
        return f
    }()
    
    /// 获取日志文件存储路径,以当天日期为文件名创建
    fileprivate static func getLogFilePath() -> String {
        let fileName = logFileNameFormatter.string(from: Date()) + ".log"
        let dirPath = self.getLogDirPath()
        let logFilePath = dirPath + "/" + fileName
        
        let isExist = FileManager.default.fileExists(atPath: logFilePath)
        if isExist == false {

            FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: [FileAttributeKey.protectionKey: FileProtectionType.complete])
            
        }
        return logFilePath
    }
    
    /// 获取日志存放文件夹目录
    fileprivate static func getLogDirPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let libraryDirectory: String = paths[0]
        let dirPath = libraryDirectory + "/logs"
        
        let isExist = FileManager.default.fileExists(atPath: dirPath)
        if isExist == false {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        return dirPath
    }
    
    fileprivate func runDisplayLink() {
        displayLink = CADisplayLink(target: self, selector: #selector(tick))
        displayLink.add(to: RunLoop.main, forMode: .common)
    }
    
    @objc func tick() {
        if lastTime == 0 {
            lastTime = displayLink.timestamp
            return
        }
        
        count += 1
        let timeDelta = displayLink.timestamp - lastTime
        if timeDelta > 1 {
            let fps = Double(count) / timeDelta
            count = 0
            lastTime = 0
            MikLog.info("FPS:\(String(format: "%.1f", fps))")
            fpsCallback?(fps)
            fpsCallback = nil
            displayLink.remove(from: RunLoop.current, forMode: .common)
            displayLink.invalidate()
        }
        
    }
    
    func getFormatString() -> String {
        let prefixStr = "-"
        let prefixLen = 8
        let timeFormat = " $Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M"
        if durationTime != nil{
            var str = "\(String(format: "%.0f", durationTime! * 1000))ms"
            while str.count < prefixLen {
                str = prefixStr.appending(str)
            }
            return str + timeFormat
        }else{
            var str = prefixStr
            
            while str.count < prefixLen {
                str = prefixStr.appending(str)
            }
            return str + timeFormat
        }
    }
}

//MARK: ---- Public ----

public extension MikLog{
    
    
    ///
    
    /// 初始化日志库
    /// - Parameter blackList: 需要过滤的黑名单
    func logInit(blackList: [String] = []){
        
        self.blackRequestList = blackList

        DispatchQueue.global().async {
            
            //控制台日志(仅DEBUG生效)
            let format = self.getFormatString()
            #if DEBUG
            self.console.format = format
            self.console.asynchronously = false
            MikLog.swiftyBeaver.addDestination(self.console)
            #endif
            
            //文件日志
            if let logFileUrl = URL.init(string: MikLog.getLogFilePath()) {
                self.file.logFileURL = logFileUrl
                self.file.format = format
                self.file.asynchronously = false
                MikLog.swiftyBeaver.addDestination(self.file)
                
                let line = FileDestination()
                line.logFileURL = logFileUrl
                line.format = "\n"
                line.asynchronously = false
                MikLog.swiftyBeaver.addDestination(line)
                
                #if DEBUG
                MikLog.debug("LogFilePath:\(logFileUrl.absoluteString)")
                #endif
            }
            
            
            MikLog.cleanLogFileWeeksAgo()
            
            MikLog.info("--- Log Begin ---")
            
            MikLog.logHardwareInformation()
            
            MikLog.shared.startPingOnce()
            
            MikLog.shared.startFPSOnce()
        }
        
    }
    
    /// 登录成功后需调用此方法,记录当前的用户email,写进日志
    func logConfig(email : String) {
        self.email = email
    }
    
    /// ping一次服务器
    /// - Parameter callback: ping结果回调
    func startPingOnce(callback : ((PingResult?) -> ())? = nil) {
        self.pingCallback = callback
        let host = "www.michaels.com"
        do {
            var config = PingConfiguration(interval: 1.0, with: 1)
            config.handleBackgroundTransitions = false
            ping = try SwiftyPing(host: host, configuration: config, queue: DispatchQueue.global())
            ping?.observer = { (response) in
                
                MikLog.shared.lastPing = response.duration
                var message = "\(response.duration * 1000) ms"
                if let error = response.error {
                    if error == .responseTimeout {
                        message = "Timeout \(message)"
                    } else {
                        print(error)
                        message = error.localizedDescription
                    }
                }
                MikLog.info("Ping #\(host): \(message)")
                
                
            }
            ping?.finished = { [weak self](result) in
                guard let self = self else { return }
                var message = "--- \(host) ping statistics ---"
                message += "\(result.packetsTransmitted) transmitted, \(result.packetsReceived) received"
                if let loss = result.packetLoss {
                    message += String(format: " %.1f%% packet loss", loss * 100)
                } else {
                    message += ""
                }
                if let roundtrip = result.roundtrip {
                    message += String(format: " round-trip min/avg/max/stddev = %.3f/%.3f/%.3f/%.3f ms", roundtrip.minimum * 1000, roundtrip.average * 1000, roundtrip.maximum * 1000, roundtrip.standardDeviation * 1000)
                }
                MikLog.info(message)
                self.pingCallback?(result)
                self.pingCallback = nil
            }
            ping?.targetCount = 4
            try ping?.startPinging()
        } catch {
            MikLog.error("Ping #\(host): Failed")
            pingCallback?(nil)
            pingCallback = nil
        }
    }
    
    
    /// 获取设备当前FPS
    func startFPSOnce(callback : ((Double) -> ())? = nil) {
        self.fpsCallback = callback
        self.runDisplayLink()
    }
    
    /// 打印设备及硬件信息
    static func logHardwareInformation(){
        
        var appVersion = ""
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            appVersion = "\(version)(\(buildVersion))"
        }
        
        MikLog.info("app version:\(appVersion)")
        MikLog.info("device modelName:\(UIDevice.mik.modelName)")
        MikLog.info("systemVersion:\(UIDevice.current.systemName + UIDevice.current.systemVersion)")
    }
    
    /// 获取日志文件目录下的所有日志文件的文件名,日期升序排序(早的日期在前面)
    static func getLogFileList() -> [String] {
        if let files = FileManager.default.subpaths(atPath: self.getLogDirPath()) {
            return files.sorted()
        }else{
            return []
        }
    }
    
    /// 获取某日志文件名的全路径
    static func getLogFullPath(fileName: String) -> String{
        return self.getLogDirPath() + "/" + fileName
    }
    
    
    /// 记录错误API日志信息
    static func saveApiLog(model : MikLogModel){
        var model = model
        model.email = MikLog.shared.email
        
        //过滤掉upload等信息的params
        if MikLog.shared.blackRequestList.contains(where: {return $0 == model.url}) {
            model.params = nil
        }
        
        let map = model.toJSON() as Any
        MikLog.shared.durationTime = model.requestDuration
        if model.isSuccess {
            MikLog.info(JSON(map))
        }else{
            MikLog.error(JSON(map))
        }
        MikLog.shared.durationTime = nil
    }
    
    //MARK: ---- 下面的方法内容将会写入日志 ----
    static func debug<T>(_ message: T ,
                         _ context: Any? = nil,
                         file: String = #file,
                         method: String = #function,
                         line: Int = #line) {
        swiftyBeaver.debug(message, file, method, line: line, context: context)
    }
    
    static func verbose<T>(_ message: T... ,
                           file: String = #file,
                           method: String = #function,
                           line: Int = #line) {
        swiftyBeaver.verbose(message, file, method, line: line)
    }
    
    static func info<T>(_ message: T... ,
                        file: String = #file,
                        method: String = #function,
                        line: Int = #line) {
        swiftyBeaver.info(message, file, method, line: line)
    }
    
    static func warning<T>(_ message: T... ,
                           file: String = #file,
                           method: String = #function,
                           line: Int = #line) {
        swiftyBeaver.warning(message, file, method, line: line)
    }
    
    static func error<T>(_ message: T... ,
                         file: String = #file,
                         method: String = #function,
                         line: Int = #line) {
        swiftyBeaver.error(message, file, method, line: line)
    }
}
