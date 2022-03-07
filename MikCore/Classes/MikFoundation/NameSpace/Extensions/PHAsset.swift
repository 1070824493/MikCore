//
//  PHAsset.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/31.
//

import UIKit
import Photos

public extension MikNameSpace where Base: PHAsset {
    
    typealias AssetDataValueTuple = (localIdentifier: String, data: Data, type: MediaType, fileExtension: String)
    
    enum MediaType {
        case unknown, image, video, gif, livePhoto
    }
    
    /// 类型
    var type: MediaType {
        switch self.base.mediaType {
        case .video: return .video
        case .image:
            if (self.base.value(forKey: "filename") as? String)?.hasSuffix("GIF") == true {
                return .gif
            }
            if #available(iOS 9.1, *) {
                if self.base.mediaSubtypes == .photoLive || self.base.mediaSubtypes.rawValue == 10 {
                    return .livePhoto
                }
            }
            return .image
        default: return .unknown
        }
    }
    
    /// 是否在云盘
    var isInCloud: Bool {
        guard let resource = PHAssetResource.assetResources(for: self.base).first else {
            return false
        }
        return !(resource.value(forKey: "locallyAvailable") as? Bool ?? true)
    }
    
    /// 宽高比
    var whRatio: CGFloat {
        return CGFloat(self.base.pixelWidth) / CGFloat(self.base.pixelHeight)
    }
    
    /// 缩略图建议大小
    var previewSize: CGSize {
        let scale: CGFloat = 2
        if self.whRatio > 1 {
            let h = min(UIScreen.main.bounds.height, 600) * scale
            let w = h * self.whRatio
            return CGSize(width: w, height: h)
        } else {
            let w = min(UIScreen.main.bounds.width, 600) * scale
            let h = w / self.whRatio
            return CGSize(width: w, height: h)
        }
    }
    
    /// 从PHAsset下载图片，默认下载原图
    @discardableResult
    static func fetchImage(for asset: PHAsset, size: CGSize = PHImageManagerMaximumSize, resizeMode: PHImageRequestOptionsResizeMode = .fast, progress: ( (CGFloat, Error?, UnsafeMutablePointer<ObjCBool>, [AnyHashable : Any]?) -> Void )? = nil, completion: @escaping ( (UIImage?, Bool) -> Void )) -> PHImageRequestID {
        let option = PHImageRequestOptions()
        option.resizeMode = resizeMode
        option.isSynchronous = true // 避免多次回调
        option.isNetworkAccessAllowed = true
        option.progressHandler = { (pro, error, stop, info) in
            DispatchQueue.main.async {
                progress?(CGFloat(pro), error, stop, info)
            }
        }
        
        return PHImageManager.default().requestImage(for: asset, targetSize: size, contentMode: .aspectFill, options: option) { (image, info) in            
            var downloadFinished = false
            if let info = info {
                downloadFinished = !(info[PHImageCancelledKey] as? Bool ?? false) && (info[PHImageErrorKey] == nil)
            }
            let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool ?? false)
            if downloadFinished {
                completion(image, isDegraded)
            }
        }
    }
    
    /// 获取视频
    static func fetchVideo(for asset: PHAsset, progress: ( (CGFloat, Error?, UnsafeMutablePointer<ObjCBool>, [AnyHashable : Any]?) -> Void )? = nil, completion: @escaping ( (AVPlayerItem?, [AnyHashable: Any]?, Bool) -> Void )) -> PHImageRequestID {
        let option = PHVideoRequestOptions()
        option.isNetworkAccessAllowed = true
        option.progressHandler = { (pro, error, stop, info) in
            DispatchQueue.main.async {
                progress?(CGFloat(pro), error, stop, info)
            }
        }
        
        // https://github.com/longitachi/ZLPhotoBrowser/issues/369#issuecomment-728679135
        
        if asset.mik.isInCloud {
            return PHImageManager.default().requestExportSession(forVideo: asset, options: option, exportPreset: AVAssetExportPresetHighestQuality, resultHandler: { (session, info) in
                // iOS11 and earlier, callback is not on the main thread.
                DispatchQueue.main.async {
                    let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool ?? false)
                    if let avAsset = session?.asset {
                        let item = AVPlayerItem(asset: avAsset)
                        completion(item, info, isDegraded)
                    }
                }
            })
        } else {
            return PHImageManager.default().requestPlayerItem(forVideo: asset, options: option) { (item, info) in
                // iOS11 and earlier, callback is not on the main thread.
                DispatchQueue.main.async {
                    let isDegraded = (info?[PHImageResultIsDegradedKey] as? Bool ?? false)
                    completion(item, info, isDegraded)
                }
            }
        }
    }
    
    /// 获取视频PHAsset的AVAsset
    @discardableResult
    static func fetchAVAsset(forVideo asset: PHAsset, completion: @escaping ( (AVAsset?, [AnyHashable: Any]?) -> Void )) -> PHImageRequestID {
        let options = PHVideoRequestOptions()
        options.version = .original
        options.deliveryMode = .automatic
        options.isNetworkAccessAllowed =  true
        
        if asset.mik.isInCloud {
            return PHImageManager.default().requestExportSession(forVideo: asset, options: options, exportPreset: AVAssetExportPresetHighestQuality) { (session, info) in
                // iOS11 and earlier, callback is not on the main thread.
                DispatchQueue.main.async {
                    if let avAsset = session?.asset {
                        completion(avAsset, info)
                    }
                }
            }
        } else {
            return PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { (avAsset, _, info) in
                DispatchQueue.main.async {
                    completion(avAsset, info)
                }
            }
        }
    }
    
    /// 获取视频PHAsset的本地路径
    static func fetchAssetFilePath(asset: PHAsset, completion: @escaping (String?) -> Void ) {
        asset.requestContentEditingInput(with: nil) { (input, info) in
            var path = input?.fullSizeImageURL?.absoluteString
            if path == nil, let dir = asset.value(forKey: "directory") as? String, let name = asset.value(forKey: "filename") as? String {
                path = String(format: "file:///var/mobile/Media/%@/%@", dir, name)
            }
            completion(path)
        }
    }
    
    /// 判断是否是.HEIC、.HEIF格式的图片
    static func isHEICImage(asset: PHAsset) -> Bool {
        guard asset.mik.type == .image else { return false }
        
        if let _ = PHAssetResource.assetResources(for: asset).first(where: {
            $0.uniformTypeIdentifier == "public.heif" || $0.uniformTypeIdentifier == "public.heic"
        }) {
            return true
        }
        return false
    }        
    
    
    /// 获取 PHAsset 的二进制
    /// - Parameters:
    ///   - isFull: 是否为原图
    ///   - complete: 处理结果回调
    static func convertAssetToData(_ assets: [PHAsset]?, isFull: Bool = true, complete: (([AssetDataValueTuple]?) -> Void)?) {
        guard let assets = assets, assets.count > 0 else { return }
        
        let group = DispatchGroup()
        
        var dataTups = [(AssetDataValueTuple)]()
        
        assets.forEach { (theAsset) in
            group.enter()
            if theAsset.mik.type == .video {
                // 视频后缀名
//                let fileExtension = String(PHAssetResource.assetResources(for: theAsset).first?.originalFilename.split(separator: ".").last?.lowercased() ?? "mov")
                // 获取到视频二进制文件
                Self.exportVideo(for: theAsset, exportType: .mov, exportQuality: .medium) { (url, err) in
                    if let url = url, let data = try? Data(contentsOf: url), !data.isEmpty {
                        dataTups.append((theAsset.localIdentifier, data, MediaType.video, ExportType.mov.rawValue))
                    }else {
                        print("未获取到视频文件")
                    }
                    group.leave()
                }
            } else if theAsset.mik.type == .image {
                // 是否是HEIF、HEIC格式
                let isHeicImage = Self.isHEICImage(asset: theAsset)
                // 获取到图片二进制文件
                self.fetchImage(for: theAsset, size: {
                    if isFull { return PHImageManagerMaximumSize }
                    return theAsset.mik.previewSize
                }()) { (img, isDegraded) in
                    let imageData: Data? = {
                        let data = img?.mik.compressToBytes()
                        if isHeicImage {
                            if let bData = data, let ciImage = CIImage(data: bData), let colorSpace = ciImage.colorSpace {
                                let context = CIContext()
                                return context.jpegRepresentation(of: ciImage, colorSpace: colorSpace, options: [:])
                            }
                        }
                        return data
                    }()
                    
                    if let imageData = imageData {
                        dataTups.append((theAsset.localIdentifier, imageData, .image, "jpeg"))
                    }else {
                        print("未获取到图片文件")
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            complete?(dataTups)
        }
    }
    
}

public extension MikNameSpace where Base: PHAsset {
    
    enum ExportType: String {
        case mov = "mov", mp4 = "mp4"
        
        var avFileType: AVFileType {
            switch self {
            case .mov: return .mov
            case .mp4: return .mp4
            }
        }
    }
    
    enum ExportQuality: String {
        case low, medium, highest
        
        var presetName: String {
            switch self {
            case .low: return AVAssetExportPresetLowQuality
            case .medium: return AVAssetExportPresetMediumQuality
            case .highest: return AVAssetExportPresetHighestQuality
            }
        }
    }
    
    /// 导出视频
    /// - Parameters:
    ///   - asset: 资源
    ///   - range: 导出时间范围
    ///   - exportType: 导出类型
    ///   - exportQuality: 导出画质
    ///   - complete: 导出结果回调
    static func exportVideo(for asset: PHAsset,
                            range: CMTimeRange = CMTimeRange(start: .zero, duration: .positiveInfinity),
                            exportType: ExportType = .mov,
                            exportQuality: ExportQuality = .medium,
                            complete: @escaping ( (URL?, Error?) -> Void )) {
        guard asset.mediaType == .video else {
            complete(nil, NSError(domain: "com.ZLPhotoBrowser.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "The mediaType of asset must be video"]))
            return
        }
        
        _ = Self.fetchAVAsset(forVideo: asset) { avAsset, _ in
            if let set = avAsset {
                Self.exportVideo(for: set, range: range, exportType: exportType, exportQuality: exportQuality, complete: complete)
            } else {
                complete(nil, NSError(domain: "com.mik.error", code: -1, userInfo: [NSLocalizedDescriptionKey: "Export failed"]))
            }
        }
    }
    
    
    /// 导出视频
    /// - Parameters:
    ///   - asset: 资源
    ///   - range: 导出时间范围
    ///   - exportType: 导出类型
    ///   - exportQuality: 导出画质
    ///   - complete: 导出结果回调
    static func exportVideo(for asset: AVAsset,
                     range: CMTimeRange = CMTimeRange(start: .zero, duration: .positiveInfinity),
                     exportType: ExportType = .mov,
                     exportQuality: ExportQuality = .medium,
                     complete: @escaping ( (URL?, Error?) -> Void )) {
        // 随机地址
        let outputUrl = URL(fileURLWithPath: NSTemporaryDirectory().appendingFormat("%@.%@", UUID().uuidString, exportType.rawValue))
        
        guard let exportSession = AVAssetExportSession(asset: asset, presetName: exportQuality.presetName) else {
            complete(nil, NSError(domain: "com.mik.error", code: -1000, userInfo: [NSLocalizedDescriptionKey: "Export failed"]))
            return
        }
        
        exportSession.outputURL = outputUrl
        exportSession.outputFileType = exportType.avFileType
        exportSession.timeRange = range
        
        exportSession.exportAsynchronously(completionHandler: {
            let suc = exportSession.status == .completed
            if exportSession.status == .failed {
                print("video export failed: \(exportSession.error?.localizedDescription ?? "")")
            }
            DispatchQueue.main.async {
                complete(suc ? outputUrl : nil, exportSession.error)
            }
        })
    }
    
}
