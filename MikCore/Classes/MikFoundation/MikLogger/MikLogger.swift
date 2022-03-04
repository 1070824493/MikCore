//
//  MikLog.swift
//  Module_Foundation
//
//  Created by ty on 2021/7/12.
//

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

}

public class MikLogger: NSObject {
    fileprivate static let shared = MikLogger()

    fileprivate static var config: MikLogConfig? = MikLogConfig()

    // 本地日志队列
    fileprivate static var mikLoggerQueue = DispatchQueue(label: "com.MikLogger.MikLogger.queue")

    fileprivate static var blackRequestList: [String] = []
    fileprivate static var fileLogUrl: URL?

    fileprivate var appType: AppType

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

        MikLogger.cleanLogFileWeeksAgo()

        MikLogger.debug(fileLogUrl?.absoluteString ?? "", nil)

        MikLogger.logHardwareInformation()
    }

    /// 登录成功后需调用此方法,记录当前的用户email,写进日志
    static func logConfig(config: MikLogConfig) {
        self.config = config
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
        let context = attributes != nil ? JSON(attributes as Any) : nil
        log(level: .debug, message: message, attributes: attributes, file: file, method: method, line: line)
    }

    static func info(_ message: String,
                     _ attributes: [String: Any]? = nil,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {
        let context = attributes != nil ? JSON(attributes as Any) : nil
        log(level: .info, message: message, attributes: attributes, file: file, method: method, line: line)
    }

    static func warn(_ message: String,
                     _ attributes: [String: Any]? = nil,
                     file: String = #file,
                     method: String = #function,
                     line: Int = #line)
    {
        let context = attributes != nil ? JSON(attributes as Any) : nil
        log(level: .warn, message: message, attributes: attributes, file: file, method: method, line: line)
    }

    static func error(_ message: String,
                      _ attributes: [String: Any]? = nil,
                      file: String = #file,
                      method: String = #function,
                      line: Int = #line)
    {
        let context = attributes != nil ? JSON(attributes as Any) : nil
        log(level: .error, message: message, attributes: attributes, file: file, method: method, line: line)
    }
}

// MARK: - --- Private ----

private extension MikLogger {
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

    static func log(level: LogLevelType,
                    message: String,
                    attributes: [String: Any]? = nil,
                    file: String = #file,
                    method: String = #function,
                    line: Int = #line)
    {
        var formatString = getFormatPrefixString() + logFileWriteFormatter.string(from: Date()) + level.levelString() + (file as NSString).lastPathComponent + "[\(line)] " + method + " - \(message)"

        if let attributes = attributes {
            formatString.append("\n\(JSON(attributes as Any))")
        }

        // 控制台日志
        #if DEBUG
        if config?.enableConsoleLog == true {
            mikLoggerQueue.async {
                print(formatString)
            }
        }
        #endif

        // 文件日志,按天异步写入单个文件
        if config?.enableFileLog == true {
            mikLoggerQueue.async {
                saveToFile(str: formatString)
            }
        }
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
