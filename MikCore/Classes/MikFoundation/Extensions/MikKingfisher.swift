//
//  MikKingfisher.swift
//  MikCore
//
//  Created by m7 on 2021/5/10.
//

import UIKit
import AVFoundation
import Kingfisher


public enum MikOptionsType {
    /// 原图
    case none
    /// 缩略图
    case thumbnail(CGSize)
    /// 自定义
    case custom(KingfisherOptionsInfo)
    
    var options: KingfisherOptionsInfo? {
        switch self {
        case .thumbnail(let size):
            let bSize = CGSize(width: size.width * 3, height: size.height * 3)
            return [.processor(DownsamplingImageProcessor(size: bSize))]
        case .custom(let ops): return ops
        default: return nil
        }
    }        
}

fileprivate extension Resource {
        
    /// 转换为缩略图地址
    /// - Parameter type: 配置项类型
    /// - Returns: 缩略图地址
    func asThumbURL(type: MikOptionsType) -> Resource? {
        let size: CGSize? = {
            switch type {
            case .thumbnail(let size): return size
            default: return nil
            }
        }()
        
        return self.asThumbURL(size: size)
    }
    
    /// 转换为缩略图地址
    /// - Parameter size: 缩略图大小
    /// - Returns: 缩略图地址
    func asThumbURL(size: CGSize?) -> Resource? {
        guard let size = size else { return self }
        
        guard self.downloadURL.host?.hasPrefix("imgproxy.") ?? false else {
            // 该地址不支持取缩略图
            return self
        }
        
        // 只保留路径第一个和最后一个元素
        let path: String? = {
            let eles = self.downloadURL.path.split(separator: "/")
            guard let first = eles.first, let last = eles.last else { return nil }
            return [first, "fill/\(Int(size.width * 1.5))/\(Int(size.height * 1.5))/ce/1", last].joined(separator: "/")
        }()
        
        guard let bPath = path else { return self }
        
        // 重组URL
        let absoluteString: String? = {
            guard var baseUrl = URL(string: "/", relativeTo: self.downloadURL)?.absoluteString else { return nil }
            baseUrl.remove(at: baseUrl.index(before: baseUrl.endIndex))
            return [baseUrl, bPath].joined(separator: "/")
        }()
        
        guard let bAbsoluteString = absoluteString, let bURL = URL(string: bAbsoluteString) else { return self }
        
        return bURL
    }
    
}

public struct MikKingfisher {
    
    /// 设置 Kingfisher 默认配置
    /// - Parameter optionsInfo: 默认配置项
    public static func configKingfisher(optionsInfo: KingfisherOptionsInfo? = nil) {
        guard let optionsInfo = optionsInfo else { return }
        KingfisherManager.shared.defaultOptions += optionsInfo
    }
    
}


// MARK: - KingfisherWrapper For UIImageView
public extension MikNameSpace where Base: UIImageView {
        
    /// 设置图片
    /// - Parameters:
    ///   - type: 配置项类型
    ///   - url: 图片地址
    ///   - placeholder: 占位图
    ///   - progressBlock: 下载进度
    ///   - completionHandler: 下载结果
    /// - Returns: 下载任务
    @discardableResult
    func setImage(type: MikOptionsType = .none,
                  url: URL?,
                  placeholder: UIImage? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url else {
            self.base.image = placeholder
            return nil
        }
        
        return self.base.kf.setImage(with: url.asThumbURL(type: type),
                             placeholder: placeholder,
                             options: type.options,
                             progressBlock: progressBlock,
                             completionHandler: completionHandler)
    }
    
    @discardableResult
    func setImage(type: MikOptionsType = .none,
                  url: String?,
                  placeholder: UIImage? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url?.mik.urlEncoding(["#","%"]), let bUrl = URL(string: url) else {
            self.base.image = placeholder
            return nil
        }
        
        return self.setImage(type: type, url: bUrl, placeholder: placeholder, progressBlock: progressBlock, completionHandler: completionHandler)
    }
        
    /// 取视频某帧图片
    /// - Parameters:
    ///   - url: 视频地址
    ///   - size: 图片大小, 默认为.zero, 取原图
    ///   - seconds: 取图片的时间点
    ///   - placeholder: 默认图片
    func setImage(with url: URL?,
                  size: CGSize = .zero,
                  seconds: TimeInterval,
                  placeholder: UIImage? = nil,
                  completeHandle:((UIImage?)->Void)? = nil)  {
        guard let url = url else {
            self.base.image = placeholder
            return
        }
        
        /// 下载并缓存图片
        func loadAndCacheImage(url: URL, cacheKey: String) {
            self.base.image = placeholder
            
            AVAssetImageDataProvider(assetImageGenerator: {
                let aImageGenerato = AVAssetImageGenerator(asset: AVAsset(url: url))
                aImageGenerato.maximumSize = size
                return aImageGenerato
            }(), time: CMTime(seconds: seconds, preferredTimescale: 600)).data { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        if let image = UIImage(data: data) {
                            self.base.image = image
                            ImageCache.default.store(image, original: data, forKey: cacheKey)
                        }
                    case .failure(_):
                        self.base.image = placeholder
                    }
                    completeHandle?(self.base.image)
                }
            }
        }
                
        let cacheKey = [url.absoluteString, "\(seconds)", "w\(size.width)_h\(size.height)"].joined(separator: "_")
        
        // 读取缓存
        ImageCache.default.retrieveImage(forKey: cacheKey) { rs in
            switch rs {
            case .success(let iRs):
                DispatchQueue.main.async {
                    self.base.image = iRs.image
                }
            case .failure(_): loadAndCacheImage(url: url, cacheKey: cacheKey)
            }
        }
    }
    
}

// MARK: - KingfisherWrapper For UIButton
public extension MikNameSpace where Base: UIButton {
   
    /// 设置图片
    /// - Parameters:
    ///   - type: 配置项类型
    ///   - url: 图片地址
    ///   - placeholder: 占位图
    ///   - progressBlock: 下载进度
    ///   - completionHandler: 下载结果
    /// - Returns: 下载任务
    @discardableResult
    func setImage(type: MikOptionsType = .none,
                  url: URL?,
                  for state: UIControl.State,
                  placeholder: UIImage? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url else {
            self.base.setImage(placeholder, for: state)
            return nil
        }
        
        return self.base.kf.setImage(with: url.asThumbURL(type: type),
                             for: state,
                             placeholder: placeholder,
                             options: type.options,
                             progressBlock: progressBlock,
                             completionHandler: completionHandler)
    }
    
    @discardableResult
    func setImage(type: MikOptionsType = .none,
                  url: String?,
                  for state: UIControl.State,
                  placeholder: UIImage? = nil,
                  progressBlock: DownloadProgressBlock? = nil,
                  completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url?.mik.urlEncoding(["#","%"]), let bUrl = URL(string: url) else {
            self.base.setImage(placeholder, for: state)
            return nil
        }
        
        return self.setImage(type: type, url: bUrl, for: state, placeholder: placeholder, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
    /// 设置背景图片
    /// - Parameters:
    ///   - type: 配置项类型
    ///   - url: 图片地址
    ///   - placeholder: 占位图
    ///   - progressBlock: 下载进度
    ///   - completionHandler: 下载结果
    /// - Returns: 下载任务
    @discardableResult
    func setBackgroundImage(type: MikOptionsType = .none,
                            url: URL?,
                            for state: UIControl.State,
                            placeholder: UIImage? = nil,
                            progressBlock: DownloadProgressBlock? = nil,
                            completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url else {
            self.base.setBackgroundImage(placeholder, for: state)
            return nil
        }
        
        return self.base.kf.setBackgroundImage(with: url.asThumbURL(type: type),
                                               for: state,
                                               placeholder: placeholder,
                                               options: type.options,
                                               progressBlock: progressBlock,
                                               completionHandler: completionHandler)
    }
    
    
    @discardableResult
    func setBackgroundImage(type: MikOptionsType = .none,
                            url: String?,
                            for state: UIControl.State,
                            placeholder: UIImage? = nil,
                            progressBlock: DownloadProgressBlock? = nil,
                            completionHandler: ((Result<RetrieveImageResult, KingfisherError>) -> Void)? = nil) -> DownloadTask? {
        guard let url = url?.mik.urlEncoding(["#","%"]), let bUrl = URL(string: url) else {
            self.base.setBackgroundImage(placeholder, for: state)
            return nil
        }
        
        return self.setBackgroundImage(type: type, url: bUrl, for: state, placeholder: placeholder, progressBlock: progressBlock, completionHandler: completionHandler)
    }
    
}
