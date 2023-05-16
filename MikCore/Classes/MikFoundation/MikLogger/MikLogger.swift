//
//  MikLog.swift
//  Module_Foundation
//
//  Created by ty on 2021/7/12.
//

import Datadog
import FirebaseCore
import FirebaseStorage
import SwiftyJSON
import UIKit
import HandyJSON

/// log will not be upload to Datadog
public func MikPrint(file: String = #file,
                     method: String = #function,
                     line: Int = #line,
                     _ item: Any...)
{
    let message = item.map { String(describing: $0) }.joined(separator: " ")
    MikLogger.debugPrint(message, file: file, method: method, line: line)
}

/// 日志库上传时用来区分APP
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

    public static var config: MikLogConfig? = MikLogConfig() {
        didSet {
            if let email = config?.email, dogLogger != nil {
                MikLogger.dogLogger.addAttribute(forKey: datadogAttributeEmail, value: email)
            }
        }
    }

    // ping
    fileprivate var ping: SwiftyPing?
    fileprivate var lastPing: Double = 0

    // fps
    fileprivate var displayLink: CADisplayLink!
    fileprivate var lastTime: CFTimeInterval = 0
    fileprivate var count: Int = 0

    fileprivate var fpsCallback: ((Double) -> ())?
    fileprivate var pingCallback: ((PingResult?) -> ())?


    fileprivate static var dogLogger = Logger.builder
        .sendNetworkInfo(true)
        .sendLogsToDatadog(true)
        .build()

    // DataDog日志上传队列
    fileprivate static var dogQueue = DispatchQueue(label: "com.MikLogger.DataDog.queue")

    // 本地日志队列
    fileprivate static var mikLoggerQueue = DispatchQueue(label: "com.MikLogger.MikLogger.queue")
    

    fileprivate static var blackRequestList: [String] = []
    fileprivate static var fileLogUrl: URL?


    fileprivate var appType: AppType

    /// SwiftyBeaver
    // api 耗时
    fileprivate static var durationTime: TimeInterval? {
        didSet {
//            let format = MikLogger.getFormatString()
//            MikLogger.console.format = format
//            MikLogger.file.format = format
        }
    }

    fileprivate static var lastUploadLogTime: TimeInterval = 0
    fileprivate static let saveLogDays = 7

    fileprivate static let datadogContext = "context"
    fileprivate static let datadogAttributeEmail = "email"

    // 日志打印时间格式
    static let logAPITimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd|HH:mm:ss.SSS"
        f.timeZone = TimeZone.current
        return f
    }()

    fileprivate enum LogLevelType {
        case debug
        case info
        case warn
        case error

        func levelString() -> String {
            switch self {
            case .debug:
                return " 💚 DEBUG "
            case .info:
                return " 💙 INFO "
            case .warn:
                return " 💛 WARN "
            case .error:
                return " ❤️ ERROR "
            }
        }
    }

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

        let fileLogUrl = URL(string: MikLogger.getLogFilePath())
        MikLogger.fileLogUrl = fileLogUrl

        MikLogger.configDatadog()

        MikLogger.cleanLogFileWeeksAgo()

        MikLogger.debug(fileLogUrl?.absoluteString ?? "", nil)
        
        MikLogger.logHardwareInformation()

        MikLogger.shared.startPingOnce()

        MikLogger.shared.startFPSOnce()
    }

    /// 登录成功后需调用此方法,记录当前的用户email,写进日志
    static func config(email: String) {
        self.config?.email = email
    }

    /// 配置是否开启控制台日志
    static func config(enableConsoleLog: Bool) {
        self.config?.enableConsoleLog = enableConsoleLog
    }


    /// 此方法会重置并替换所有的config
    static func logConfig(config: MikLogConfig) {
        self.config = config
    }

    static func uploadLogFile() {
        guard Date().timeIntervalSince1970 - lastUploadLogTime > 60 else {
            MikToast.showToast(style: .information(title: "Operation too frequent, wait a minute", message: nil))
            return
        }
        lastUploadLogTime = Date().timeIntervalSince1970
        let view = UIApplication.shared.windows.first
        MikToast.showHUD(in: view)

        MikLogger.logHardwareInformation()
        MikLogger.shared.startPingOnce { _ in
            MikLogger.shared.startFPSOnce { _ in

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
                    guard let fileName = MikLogger.getLogFileList().last else {
                        MikToast.hideHUD(in: view)
                        return
                    }

                    let fullPath = MikLogger.getLogFullPath(fileName: fileName)
                    let url = URL(fileURLWithPath: fullPath)
                    let storage = Storage.storage()

                    var logFileName = MikLogger.logFileNameFormatter.string(from: Date())

                    // 文件名邮箱
                    if let email = MikLogger.config?.email {
                        logFileName = logFileName + "|" + email
                    }

                    logFileName = logFileName + "|" + UIDevice.mik.modelName + "|" + UIDevice.current.systemName + UIDevice.current.systemVersion + ".log"

                    let storageRef = storage.reference(withPath: MikLogger.shared.appType.uploadFilePath)
                    let riversRef = storageRef.child("\(logFileName)")

                    let task = riversRef.putFile(from: url, metadata: nil) { _, error in

                        NSObject.cancelPreviousPerformRequests(withTarget: self) // 取消超时任务
                        DispatchQueue.main.async {
                            MikToast.hideHUD(in: view)
                        }
                        if error == nil {
                            MikToast.showToast(style: .success(title: "upload success", message: nil))
                        } else {
                            MikToast.showToast(style: .error(title: "upload failed", message: nil))
                        }
                    }

                    // 此方法没开代理超时时间特别久,故手动增加一个超时30S
                    self.perform(#selector(self.timeoutTask(task:)), with: task, afterDelay: 30)
                }
            }
        }
    }

    /// 记录错误API日志信息
    static func saveApiLog(model: MikRequestLogModel) {
        var model = model
        model.email = MikLogger.config?.email

        // 过滤掉黑名单中打印信息
        if MikLogger.blackRequestList.contains(where: { $0 == model.url }) {
            model.params = nil
            model.response = nil
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

        log(level: .debug, message: message, attributes: attributes, file: file, method: method, line: line)
        dataDoglog(level: .debug, message: message, attributes: attributes, file: file, method: method, line: line)
    }

    static func info(_ message: String,
                     _ attributes: [String: Any]? = nil,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {

        log(level: .info, message: message, attributes: attributes, file: file, method: method, line: line)
        dataDoglog(level: .info, message: message, attributes: attributes, file: file, method: method, line: line)

    }

    static func warn(_ message: String,
                     _ attributes: [String: Any]? = nil,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {

        log(level: .warn, message: message, attributes: attributes, file: file, method: method, line: line)

        dataDoglog(level: .warn, message: message, attributes: attributes, file: file, method: method, line: line)
    }

    static func error(_ message: String,
                      _ attributes: [String: Any]? = nil,
                      file: String = #file,
                      method: String = #function,
                      line: Int = #line)
    {

        log(level: .error, message: message, attributes: attributes, file: file, method: method, line: line)

        dataDoglog(level: .error, message: message, attributes: attributes, file: file, method: method, line: line)

    }
}

// MARK: - --- Private ----

fileprivate extension MikLogger {
    static func debugPrint(_ message: String,
                                       file: String = #file,
                                       method: String = #function,
                                       line: Int = #line)
    {
        #if DEBUG
            DispatchQueue.global().async {
                print(message)
            }
        #endif
    }


    /// 本地日志记录方法
    static func log(level: LogLevelType,
                    message: String,
                    attributes: [String: Any]? = nil,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line)
    {

        var formatString = getFormatPrefixString() + logFileWriteFormatter.string(from: Date()) + level.levelString() + (file as NSString).lastPathComponent + "[\(line)] " + method + " - \(message)"

        if let attributes = attributes{
            formatString.append("\n\(JSON(attributes as Any))")
        }

        //控制台日志
        #if DEBUG
        if config?.enableConsoleLog == true {
            mikLoggerQueue.async {
                print(formatString)
            }
        }
        #endif

        //文件日志,按天异步写入单个文件
        if config?.enableFileLog == true {
            mikLoggerQueue.async {
                saveToFile(str: formatString)
            }
        }
    }

    /// dataDog日志记录方法
    static func dataDoglog(level: LogLevelType,
                    message: String,
                    attributes: [String: Any]? = nil,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line)
    {
        var dataDogAttributes : [String: JSON]? = nil
        if let context = attributes != nil ? JSON(attributes as Any) : nil{
            dataDogAttributes = [datadogContext : context]
        }else{
            dataDogAttributes = nil
        }
        if config?.enableDataDogLog == true, dogLogger != nil {
            dogQueue.async {
                switch level {
                case .debug:
                    MikLogger.dogLogger.debug(message, attributes: dataDogAttributes)
                case .info:
                    MikLogger.dogLogger.info(message, attributes: dataDogAttributes)
                case .warn:
                    MikLogger.dogLogger.warn(message, attributes: dataDogAttributes)
                case .error:
                    MikLogger.dogLogger.error(message, attributes: dataDogAttributes)
                }
            }
        }
    }



    static func configDatadog() {
        let clientToken = "pub99373724a53eae5627a9465d91362e14"
        let environment = "dev00"
        let dogConfig = Datadog.Configuration
            .builderUsing(clientToken: clientToken, environment: environment)
            .set(serviceName: MikLogger.shared.appType.serverName)
            .build()
        Datadog.initialize(appContext: .init(), trackingConsent: .granted, configuration: dogConfig)

        self.dogLogger = Logger.builder
            .sendNetworkInfo(true)
            .sendLogsToDatadog(true)
            .build()
    }

    @objc static func timeoutTask(task: StorageUploadTask) {
        task.cancel()
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
}

// MARK: - --- FPS & Ping----

extension MikLogger {
    /// 获取设备当前FPS
    func startFPSOnce(callback: ((Double) -> ())? = nil) {
        self.fpsCallback = callback
        self.runDisplayLink()
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
}

// MARK: - --- Private Util Methods ----

private extension MikLogger {

    static func saveToFile(str: String) -> Bool {
        guard let url = fileLogUrl else { return false }

        let line = str + "\n"
        guard let data = line.data(using: String.Encoding.utf8) else { return false }

        return write(data: data, to: url)
    }

    static func write(data: Data, to url: URL) -> Bool {

        var success = false
        let coordinator = NSFileCoordinator(filePresenter: nil)
        let fileManager = FileManager.default
        var error: NSError?
        coordinator.coordinate(writingItemAt: url, error: &error) { url in
            do {
                if fileManager.fileExists(atPath: url.path) == false {

                    let directoryURL = url.deletingLastPathComponent()
                    if fileManager.fileExists(atPath: directoryURL.path) == false {
                        try fileManager.createDirectory(
                            at: directoryURL,
                            withIntermediateDirectories: true
                        )
                    }
                    fileManager.createFile(atPath: url.path, contents: nil)

                    #if os(iOS) || os(watchOS)
                    if #available(iOS 10.0, watchOS 3.0, *) {
                        var attributes = try fileManager.attributesOfItem(atPath: url.path)
                        attributes[FileAttributeKey.protectionKey] = FileProtectionType.none
                        try fileManager.setAttributes(attributes, ofItemAtPath: url.path)
                    }
                    #endif
                }

                let fileHandle = try FileHandle(forWritingTo: url)
                fileHandle.seekToEndOfFile()
                fileHandle.write(data)

//                fileHandle.synchronizeFile()

                fileHandle.closeFile()
                success = true
            } catch {
                print("MikLogger could not write to file \(url).")
            }
        }

        if let error = error {
            print("MikLogger failed writing file with error: \(String(describing: error))")
            return false
        }

        return success
    }

    static func getFormatPrefixString() -> String {
        let prefixStr = "-"
        let prefixLen = 8

        var str = prefixStr
        if let durationTime = durationTime, durationTime > 0 {
            str = "\(String(format: "%.0f", durationTime * 1000))ms"
        }
        while str.count < prefixLen {
            str = prefixStr.appending(str)
        }
        return str + " "
    }

    /// 删除最近n天以外的日志
    static func cleanLogFileWeeksAgo() {
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

    /// 获取日志文件目录下的所有日志文件的文件名,日期升序排序(早的日期在前面)
    static func getLogFileList() -> [String] {
        if let files = FileManager.default.subpaths(atPath: self.getLogDirPath()) {
            return files.sorted()
        } else {
            return []
        }
    }

    /// 获取日志存放文件夹目录
    static func getLogDirPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let libraryDirectory: String = paths[0]
        let dirPath = libraryDirectory + "/logs"

        let isExist = FileManager.default.fileExists(atPath: dirPath)
        if isExist == false {
            try? FileManager.default.createDirectory(atPath: dirPath, withIntermediateDirectories: true, attributes: nil)
        }
        return dirPath
    }

    /// 获取日志文件存储路径,以当天日期为文件名创建
    static func getLogFilePath() -> String {
        let fileName = logFileNameFormatter.string(from: Date()) + ".log"
        let dirPath = self.getLogDirPath()
        let logFilePath = dirPath + "/" + fileName

        let isExist = FileManager.default.fileExists(atPath: logFilePath)
        if isExist == false {
            FileManager.default.createFile(atPath: logFilePath, contents: nil, attributes: [FileAttributeKey.protectionKey: FileProtectionType.complete])
        }
        return logFilePath
    }

    // 本地存储的日志文件时间格式/上传到服务器的文件名字
    static let logFileNameFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "YYYY-MM-dd"
        f.timeZone = TimeZone.current
        return f
    }()

    // 日志记录的时间格式
    static let logFileWriteFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        f.timeZone = TimeZone.current
        return f
    }()



    /// 获取某日志文件名的全路径
    static func getLogFullPath(fileName: String) -> String {
        return self.getLogDirPath() + "/" + fileName
    }
}
