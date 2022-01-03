//
//  MikLog.swift
//  Module_Foundation
//
//  Created by ty on 2021/7/12.
//


import SwiftyBeaver
import SwiftyJSON
import UIKit

/// log will not be upload to Datadog
public func MikPrint(file: String = #file,
                     method: String = #function,
                     line: Int = #line,
                     _ item: Any...)
{
    let message = item.map { String(describing: $0) }.joined(separator: " ")
    MikLogger.debugPrint(message, file: file, method: method, line: line)
}

private enum AppType: String {
    case buyer = "com.michaels.MikMobile.BuyerTool"
    case seller = "com.michaels.sellertool"
    case shopAndScan = "com.michaels.MikMobile.BuyerTool.ShopAndScanAPP"
    case shopAndScanIpad = "com.michaels.shopscanverificationapp"
    case unknown

    var bundleId: String {
        switch self {
        case .unknown:
            return Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String ?? self.rawValue
        default:
            return self.rawValue
        }
    }

    /// Datadog Service Name
    var serverName: String {
        switch self {
        case .buyer:
            return "mobile-ios-buyer"
        case .seller:
            return "mobile-ios-seller"
        case .shopAndScan:
            return "mobile-ios-shopscan"
        case .shopAndScanIpad:
            return "mobile-ios-shopscan-ipad"
        case .unknown:
            return self.bundleId
        }
    }

    var uploadFilePath: String {
        switch self {
        case .buyer:
            return "iOSBuyerLog"
        case .seller:
            return "iOSSellerLog"
        case .shopAndScan:
            return "iOSShopScanLog"
        case .shopAndScanIpad:
            return "iOSShopScanIpadLog"
        case .unknown:
            return self.bundleId
        }
    }
}

public class MikLogger: NSObject {

    fileprivate static let shared = MikLogger()

    // ping
    fileprivate var ping: SwiftyPing?
    fileprivate var lastPing: Double = 0

    // fps
    fileprivate var displayLink: CADisplayLink!
    fileprivate var lastTime: CFTimeInterval = 0
    fileprivate var count: Int = 0

    fileprivate var fpsCallback: ((Double) -> ())?
    fileprivate var pingCallback: ((PingResult?) -> ())?


    fileprivate static var config: MikLogConfig?

    fileprivate static var blackRequestList: [String] = []

    /// call init app type
    fileprivate var appType: AppType

    // api 耗时
    fileprivate static var durationTime: TimeInterval? {
        didSet {
            let format = MikLogger.getFormatString()
            MikLogger.console.format = format
            MikLogger.file.format = format
        }
    }

    fileprivate static var lastUploadLogTime: TimeInterval = 0

    fileprivate static let console = ConsoleDestination() // log to Xcode Console
    fileprivate static let file = FileDestination() // log to file



    static let swiftyBeaver = SwiftyBeaver.self

    fileprivate static let saveLogDays = 7

    fileprivate static let datadogContext = "context"
    fileprivate static let datadogAttributeEmail = "email"
    fileprivate static let datadogAttributeFCMToken = "fcmToken"

    override private init() {
        if let bundleId = Bundle.main.object(forInfoDictionaryKey: "CFBundleIdentifier") as? String, let type = AppType(rawValue: bundleId) {
            self.appType = type
        } else {
            self.appType = .unknown
        }
    }
}

// MARK: - --- Public ----

public extension MikLogger {
    /// 初始化日志库
    /// - Parameter blackList: 需要过滤的黑名单
    static func logInit(blackList: [String] = []) {

        MikLogger.blackRequestList = blackList

        DispatchQueue.global().async {

            // 控制台日志(仅DEBUG生效)
            let format = MikLogger.getFormatString()
            #if DEBUG
            MikLogger.console.format = format
            MikLogger.swiftyBeaver.addDestination(MikLogger.console)
            #endif

            // 文件日志(需求：暂时不需要记录文件日志了)
//            if let logFileUrl = URL(string: MikLogger.getLogFilePath()) {
//                self.file.logFileURL = logFileUrl
//                self.file.format = format
//                MikLogger.swiftyBeaver.addDestination(self.file)
//
//                let line = FileDestination()
//                line.logFileURL = logFileUrl
//                line.format = "\n"
//                MikLogger.swiftyBeaver.addDestination(line)
//            }


            MikLogger.cleanLogFileWeeksAgo()

            MikLogger.logHardwareInformation()

            MikLogger.shared.startPingOnce()

            MikLogger.shared.startFPSOnce()
            
            MikLogger.debug("test", ["key" : "testValue", "key2" : false])
        }
    }

    /// 登录成功后需调用此方法,记录当前的用户email,写进日志
    static func logConfig(config: MikLogConfig) {
        self.config = config
    }


    /// 记录错误API日志信息
    static func saveApiLog(model: MikRequestLogModel) {
        var model = model
        model.email = MikLogger.config?.email

        // 过滤掉upload等信息的params
        if MikLogger.blackRequestList.contains(where: { $0 == model.url }) {
            model.params = nil
        }

        MikLogger.durationTime = model.requestDuration
        if model.isSuccess {
            MikLogger.info(model.url ?? "", model.toJSON())
        } else {
            MikLogger.error(model.url ?? "", model.toJSON())
        }
        MikLogger.durationTime = nil
    }

    // MARK: - --- method below: log will be upload to Datadog  ----

    static func debug(_ message: String,
                      _ attributes: [String: Any]? = nil,
                      file: String = #file,
                      method: String = #function,
                      line: Int = #line)
    {
        swiftyBeaver.debug(message, file, method, line: line, context: attributes)
    }

    static func info(_ message: String,
                     _ attributes: [String: Any]? = nil,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {
        swiftyBeaver.info(message, file, method, line: line, context: attributes)
    }

    static func warn(_ message: String,
                     _ attributes: [String: Any]? = nil,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {
        swiftyBeaver.warning(message, file, method, line: line, context: attributes)
    }

    static func error(_ message: String,
                      _ attributes: [String: Any]? = nil,
                      file: String = #file,
                      method: String = #function,
                      line: Int = #line)
    {
        swiftyBeaver.error(message, file, method, line: line, context: attributes)
    }
}

// MARK: - --- Private ----

extension MikLogger {




    fileprivate static func debugPrint(_ message: String,
                                       file: String = #file,
                                       method: String = #function,
                                       line: Int = #line)
    {
        swiftyBeaver.debug(message, file, method, line: line)
    }

    /// 删除最近n天以外的日志
    fileprivate static func cleanLogFileWeeksAgo() {
        let files = self.getLogFileList()

        if files.count > MikLogger.saveLogDays {
            for (index, value) in files.enumerated() {
                if index < files.count - MikLogger.saveLogDays {
                    let needDeletePath = self.getLogDirPath() + "/" + value
                    do {
                        try FileManager.default.removeItem(atPath: needDeletePath)
                    } catch {}
                }
            }
        }
    }

    /// 获取当天日志文件大小
    fileprivate static func getLogFileSize() -> CLongLong {
        do {
            let attr = try FileManager.default.attributesOfItem(atPath: self.getLogFilePath())
            if let size = attr[FileAttributeKey.size] as? CLongLong {
                return size
            } else {
                return 0
            }
        } catch {
            return 0
        }
    }

    // 本地存储的日志文件时间格式/上传到服务器的文件名字
    fileprivate static let logFileNameFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd"
        f.timeZone = TimeZone.current
        return f
    }()

    // API调用时间格式
    static let logAPITimeFormatter: DateFormatter = {
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
            MikLogger.info("FPS:\(String(format: "%.1f", fps))")
            fpsCallback?(fps)
            fpsCallback = nil
            displayLink.remove(from: RunLoop.current, forMode: .common)
            displayLink.invalidate()
        }
    }

    static func getFormatString() -> String {
        let prefixStr = "-"
        let prefixLen = 8
        let timeFormat = " $Dyyyy-MM-dd HH:mm:ss.SSS$d $C$L$c $N.$F:$l - $M $X"
        if durationTime != nil {
            var str = "\(String(format: "%.0f", durationTime! * 1000))ms"
            while str.count < prefixLen {
                str = prefixStr.appending(str)
            }
            return str + timeFormat
        } else {
            var str = prefixStr

            while str.count < prefixLen {
                str = prefixStr.appending(str)
            }
            return str + timeFormat
        }
    }

    /// ping一次服务器
    /// - Parameter callback: ping结果回调
    func startPingOnce(callback: ((PingResult?) -> ())? = nil) {
        self.pingCallback = callback
        let host = "www.michaels.com"
        do {
            var config = PingConfiguration(interval: 1.0, with: 1)
            config.handleBackgroundTransitions = false
            ping = try SwiftyPing(host: host, configuration: config, queue: DispatchQueue.global())
            ping?.observer = { response in

                MikLogger.shared.lastPing = response.duration
                var message = "\(response.duration * 1000) ms"
                if let error = response.error {
                    if error == .responseTimeout {
                        message = "Timeout \(message)"
                    } else {
                        print(error)
                        message = error.localizedDescription
                    }
                }
                MikLogger.info("Ping #\(host): \(message)")
            }
            ping?.finished = { [weak self] result in
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
                MikLogger.info(message)
                self.pingCallback?(result)
                self.pingCallback = nil
            }
            ping?.targetCount = 4
            try ping?.startPinging()
        } catch {
            MikLogger.error("Ping #\(host): Failed")
            pingCallback?(nil)
            pingCallback = nil
        }
    }

    /// 获取设备当前FPS
    func startFPSOnce(callback: ((Double) -> ())? = nil) {
        self.fpsCallback = callback
        self.runDisplayLink()
    }

    /// 打印设备及硬件信息
    static func logHardwareInformation() {
        var appVersion = ""
        if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String, let buildVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
            appVersion = "\(version)(\(buildVersion))"
        }

        MikLogger.info("app version:\(appVersion)")
        MikLogger.info("device modelName:\(UIDevice.mik.modelName)")
        MikLogger.info("systemVersion:\(UIDevice.current.systemName + UIDevice.current.systemVersion)")
    }

    /// 获取日志文件目录下的所有日志文件的文件名,日期升序排序(早的日期在前面)
    static func getLogFileList() -> [String] {
        if let files = FileManager.default.subpaths(atPath: self.getLogDirPath()) {
            return files.sorted()
        } else {
            return []
        }
    }

    /// 获取某日志文件名的全路径
    static func getLogFullPath(fileName: String) -> String {
        return self.getLogDirPath() + "/" + fileName
    }
}
