//
//  UploadFileModel.swift
//  Demo
//
//  Created by gaowei on 2021/4/17.
//

import Foundation

public enum FileType: Equatable {
    case image(suffix: String)
    case video(suffix: String)
    case pdf(suffix: String)
    
    public static func == (lhs: FileType, rhs: FileType) -> Bool {
        switch (lhs, rhs) {
        case (.image(let lSuffix), .image(let rSuffix)): return lSuffix == rSuffix
        case (.video(let lSuffix), .video(let rSuffix)): return lSuffix == rSuffix
        case (.pdf(let lSuffix), .pdf(let rSuffix)): return lSuffix == rSuffix
        default: return false
        }
    }
    
    public var mimeType: String {
        switch self {
        case .image(let suffix): return "image/\(suffix)"
        case .video(let suffix): return "video/\(suffix)"
        case .pdf(let suffix): return "pdf/\(suffix)"
        }
    }
    
    /// File suffix
    public var suffix: String {
        switch self {
        case .image(let suffix): return suffix
        case .video(let suffix): return suffix
        case .pdf(let suffix): return suffix
        }
    }
    
    public var sourceType: String? {
        switch self {
        case .image(_): return "IMAGE"
        case .video(_): return "VIDEO"
        case .pdf(_): return "PDF"
        }
    }
    
    public var withName: String { "files" }
}

public class UploadFileModel: NSObject {
    
    public var data: Data?
    
    public var fileName: String?
    
    public var fileType: FileType = .image(suffix: "jpeg")
    
    /// 随机文件名
    static public func randomFileName(fileType: FileType, index: Int) -> String {
        return DateFormatter.mik.formatter("yyyyMMddHHmmss").string(from: Date()) + "\(index).\(fileType.suffix)"
    }
}


