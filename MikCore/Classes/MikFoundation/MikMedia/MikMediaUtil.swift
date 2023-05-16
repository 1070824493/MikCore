//
//  MikMediaUtil.swift
//  SellerMobile
//
//  Created by m7 on 2021/3/31.
//

import Foundation
import Photos
import ZLPhotoBrowser


public enum MikMediaType {
    public enum AlbumStyle {
        /// 只允许选择图片模式（max: 选取图片上限, isAllowSelectOriginal: 是否原图）
        case image(max: Int, isAllowSelectOriginal: Bool)
        /// 只允许选择视频模式（max: 选取图片上限）
        case video(max: Int)
        /// 混合模式模式（max: 资源上限, videoMax: 视频上限, isAllowSelectOriginal: 是否原图）
        case mix(max: Int, videoMax: Int, isAllowSelectOriginal: Bool)
        /// 快捷裁减模式
        case quickClip
    }
        
    /// 相机（isAllowRecordVideo: 是否允许录制视频）
    case camera(isAllowRecordVideo: Bool)
    /// 相册（style：相册样式, isAllowTakePhoto: 是否允许拍照）
    case album(style: AlbumStyle, isAllowTakePhoto: Bool)
}

/// 文件资源类型
public enum MikDocumentSourceType: String, CaseIterable {
    case image = "public.image", video = "public.movie", pdf = "com.adobe.pdf"
}

/// 文件类型
public enum MikMediaPreviewType : Int {
    /// 图片
    case image
    /// 视频
    case video
}

/// 地图类型
public enum MikMapsType {
    
    /**
     URL Link Docs
     https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
     https://developers.google.com/maps/documentation/urls/ios-urlscheme#search
     https://developers.google.com/waze/deeplinks#search
     */
    
    case apple(address: String?, latitude: Double, longitude: Double)
    case google(address: String?, latitude: Double, longitude: Double)
    case waze(address: String?, latitude: Double, longitude: Double)
    
    var title: String? {
        switch self {
        case .apple(_, _, _): return "Maps"
        case .google(_, _, _): return "Google Maps"
        case .waze(_, _, _): return "Waze"
        }
    }
    
    var url: URL? {
        switch self {
        case .apple(let address, let latitude, let longitude):
            let q = ["Michaels", address].compactMap({ $0 }).joined(separator: "+")
            let sll = ["\(latitude)", "\(longitude)"].joined(separator: ",")
            guard let urlText = "http://maps.apple.com/?q=\(q)&sll=\(sll))&z=10&t=s".mik.urlEncoding() else {
                return nil
            }
            return URL(string: urlText)
            
        case .google(let address, let latitude, let longitude):
            let q = ["Michaels", address].compactMap({ $0 }).joined(separator: "+")
            let center = ["\(latitude)", "\(longitude)"].joined(separator: ",")
            guard let urlText = "https://www.google.com/maps/?q=\(q)&center=\(center)".mik.urlEncoding() else {
                return nil
            }
            return URL(string: urlText)
            
        case .waze(let address, let latitude, let longitude):
            let q = ["Michaels", address].compactMap({ $0 }).joined(separator: "+")
            let ll = ["\(latitude)", "\(longitude)"].joined(separator: ",")
            guard let urlText = "https://waze.com/ul?q=\(q)&ll=\(ll)&navigate=yes".mik.urlEncoding() else {
                return nil
            }
            return URL(string: urlText)
        }
    }
}

/// 展示资源数据
public typealias MikMediaPreviewData = (mediaValue : Any?,mediaType : MikMediaPreviewType)

fileprivate extension ZLPhotoConfiguration {
    
    /// 扩展 ZLPhotoConfiguration 配置, 是否允许拍照时自动保存至相册
    static var allowSaveToAlbumWhenTakePhotoKey: Void?
    var allowSaveToAlbumWhenTakePhoto: Bool? {
        get {
            return objc_getAssociatedObject(self, &ZLPhotoConfiguration.allowSaveToAlbumWhenTakePhotoKey) as? Bool
        }
        set {
            objc_setAssociatedObject(self, &ZLPhotoConfiguration.allowSaveToAlbumWhenTakePhotoKey, newValue , .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// 更新配置
    static func updateConfiguration(type: MikMediaType) {
        ZLPhotoConfiguration.resetConfiguration()
        let config = ZLPhotoConfiguration.default()
        config.allowDragSelect = true
        config.canSelectAsset = { _ in true }
        config.noAuthorityCallback = { _ in
            guard let appSetting = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            UIApplication.shared.open(appSetting, options: [:], completionHandler: nil)
        }
        
        switch type {
        case .camera(let isAllowRecordVideo):
            config.allowRecordVideo = isAllowRecordVideo
            config.allowSaveToAlbumWhenTakePhoto = true
        case .album(let style, let isAllowTakePhoto):
            config.allowTakePhoto = isAllowTakePhoto
            
            switch style {
            case .image(let max, let isAllowSelectOriginal):
                config.allowSelectVideo = false
                config.allowSelectOriginal = isAllowSelectOriginal
                config.maxSelectCount = max
            case .video(let max):
                config.allowSelectImage = false
                config.maxVideoSelectCount = max
                config.maxSelectVideoDuration = 999999
            case .mix(let max, let videoMax, let isAllowSelectOriginal):
                config.maxSelectCount = max
                config.maxVideoSelectCount = videoMax
                config.allowSelectOriginal = isAllowSelectOriginal
                config.maxSelectVideoDuration = 999999
            case .quickClip:
                config.allowSelectVideo = false
                config.allowSelectOriginal = true
                config.maxSelectCount = 1
                config.showClipDirectlyIfOnlyHasClipTool = true
                config.editAfterSelectThumbnailImage = true
                config.saveNewImageAfterEdit = false
                config.editImageTools = [.clip]
                config.editImageClipRatios = [.wh1x1]
            }
        }
    }
    
}

public class MikMediaUtil {
    
    /// 打开相机
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - isAllowRecordVideo: 是否允许拍摄视频
    ///   - complete: 完成回调
    public static func openCamera(at viewController: UIViewController?, allowRecordVideo: Bool, complete: ((UIImage?, URL?) -> Void)?) {
        guard let viewController = viewController else { return }
        
        /// 更新配置
        ZLPhotoConfiguration.updateConfiguration(type: .camera(isAllowRecordVideo: allowRecordVideo))
        
        let camera = ZLCustomCamera()
        camera.takeDoneBlock = { image, url in
            if let img = image, ZLPhotoConfiguration.default().allowSaveToAlbumWhenTakePhoto == true {
                ZLPhotoManager.saveImageToAlbum(image: img, completion: nil)
            }
            complete?(image,url)
        }
        viewController.showDetailViewController(camera, sender: nil)
    }
    
    /// 打开相册
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - style: 模式
    ///   - isAllowTakePhoto: 是否允许拍照
    ///   - selectedAssets: 当前已选中的胶卷
    ///   - complete: 完成回调
    public static func openAlbum(at viewController: UIViewController?, style: MikMediaType.AlbumStyle, isAllowTakePhoto: Bool = true, selectedAssets: [PHAsset]? = nil, complete: (([UIImage], [PHAsset], Bool) -> Void)?) {
        guard let viewController = viewController else { return }
        
        /// 更新配置
        ZLPhotoConfiguration.updateConfiguration(type: .album(style: style, isAllowTakePhoto: isAllowTakePhoto))
        
        let photoPreview = ZLPhotoPreviewSheet(selectedAssets: selectedAssets ?? [PHAsset]())
        photoPreview.selectImageBlock = complete
        photoPreview.showPhotoLibrary(sender: viewController)
    }
    
    /// 打开文件夹
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - types: 资源类型
    ///   - proxy: 代理
    public static func openFile(at viewController: UIViewController?, types: [MikDocumentSourceType] = MikDocumentSourceType.allCases, proxy: MikDocumentProxy) {
        guard let viewController = viewController else { return }
                
        let document = UIDocumentPickerViewController.init(documentTypes: types.map({ $0.rawValue }), in: .open)
        document.delegate = proxy
        viewController.present(document, animated: true, completion: nil)
    }
    
    /// 打开外部地图
    /// - Parameters:
    ///   - viewController: 父控制器
    ///   - title: 弹窗标题
    ///   - messages: 弹窗信息
    ///   - mapTypes: 地图类型
    ///   - failure: 失败回调
    public static func openMaps(at viewController: UIViewController?, title: String? = nil, messages: String? = nil, mapTypes: [MikMapsType]?, failure: (() -> Void)? = nil) {
        guard let viewController = viewController, let mapTypes = mapTypes, !mapTypes.isEmpty else {
            failure?()
            return
        }
        
        let actionInfos = mapTypes.compactMap({ type -> (String?, URL)? in
            guard let url = type.url else { return nil }
            return (type.title, url)
        })
        
        guard !actionInfos.isEmpty else {
            failure?()
            return
        }
        
        let alertController = UIAlertController(title: title, message: messages, preferredStyle: .actionSheet)
        
        defer {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            viewController.present(alertController, animated: true, completion: nil)
        }
        
        for (title, url) in actionInfos {
            let action = UIAlertAction(title: title, style: .default, handler: { _ in
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            })
            alertController.addAction(action)
        }
    }
    
}

// MARK: - Preview
public extension MikMediaUtil {
    
    /// 浏览图片或视频 数据传MikMediaPreviewData数组
    /// - Parameters:
    ///   - viewController: 当前控制器
    ///   - datas: MikMediaPreviewData数组
    ///   - previewData: 当前显示的多媒体
    ///   - showSelect: 是否显示选择按钮
    static func preview(at viewController: UIViewController?, datas: [MikMediaPreviewData], previewData: MikMediaPreviewData?, showSelect: Bool = false) {
        guard let viewController = viewController , !datas.isEmpty else { return }
        /// 展示数据源
        var list = [Any]()
        /// 每个数据对应的文件类型
        var previewTypeList = [MikMediaPreviewType]()
        var index : Int = 0
        /// 循环传进来的数据 组装成新的数据 传给第三方
        func assemblyData(){
            /// 检查值是否相等
            func checkValueIsEqual(previewDataValue : Any , value : Any)->Bool{
                if let v1 = previewDataValue as? PHAsset, let v2 = value as? PHAsset, v1 == v2 {
                    return true
                }else if let v1 = previewDataValue as? UIImage, let v2 = value as? UIImage, v1 == v2 {
                    return true
                }else if let v1 = previewDataValue as? URL, let v2 = value as? URL, v1 == v2 {
                    return true
                }else if  let v1 = previewDataValue as? String, let v2 = value as? String, v1 == v2 {
                    return true
                }
                return false
            }
 
            datas.forEach { (mediaPreviewData ) in
                var isContinue = false
                if let value = mediaPreviewData.mediaValue {
                    if value is PHAsset {
                        list.append(value)
                        previewTypeList.append(mediaPreviewData.mediaType)
                    }else if value is UIImage{
                        list.append(value)
                        previewTypeList.append(mediaPreviewData.mediaType)
                    }else if value is URL{
                        list.append(value)
                        previewTypeList.append(mediaPreviewData.mediaType)
                    }else if let urlStr = value as? String, let url = URL(string: urlStr) {
                        list.append(url)
                        previewTypeList.append(mediaPreviewData.mediaType)
                    }else{
                         isContinue = true
                    }
                    if !isContinue, let previewDataValue = previewData?.mediaValue , checkValueIsEqual(previewDataValue: previewDataValue, value: value){
                        index = list.count - 1
                    }
                }
            }
        }
        assemblyData()
        preview(at: viewController, datas: list, previewTypeList: previewTypeList, index: index, showSelect: showSelect)
    }
    
    /// 展示
    /// - Parameters:
    ///   - viewController: 当前控制器
    ///   - datas: 展示数据  Must be one of PHAsset, UIImage and URL, will filter ohers in init function.
    ///   - previewTypeList: 资源类型数组
    ///   - index: 需要展示的位置
    ///   - showSelect: 是否显示选择按钮
    private static func preview(at viewController: UIViewController, datas: [Any], previewTypeList: [MikMediaPreviewType], index: Int = 0, showSelect: Bool = false) {
        guard !datas.isEmpty  else { return }
        
        let previewVC = ZLImagePreviewController(datas: datas, index: index < 0 ? 0 : index, showSelectBtn: showSelect, showBottomView: showSelect, urlType: { (url) -> ZLURLType in
            /// 检查这个url的类型
            func check()-> ZLURLType{
                if let firstIndex = datas.firstIndex(where: {
                    if let u = $0 as? URL , u == url {return true}
                    return false
                }) , firstIndex < previewTypeList.count {
                    return previewTypeList[firstIndex] == .video ? .video : .image
                }
                return .image
            }
            return check()
        }) { (url, imgView, progressBlock, finishBlock) in
            imgView.mik.setImage(type: .none, url: url, placeholder: nil) { (receivedSize, totalSize) in
                progressBlock(CGFloat(Float(receivedSize) / Float(totalSize)))
            } completionHandler: { (result) in
                finishBlock()
            }
        }
        previewVC.modalPresentationStyle = .fullScreen
        viewController.present(previewVC, animated: true, completion: nil)
    }
    
}


// MARK: - MikDocumentProxy
public class MikDocumentProxy: NSObject, UIDocumentPickerDelegate {
    public enum FileType {
        case unkonw, image, video, pdf
    }
    
    public struct FileValue {
        public var url: URL?
        public var data: Data?
        public var extensionName: String? { url?.pathExtension.lowercased() }
        public var fileType: FileType {
            guard let extensionName = extensionName, !extensionName.isEmpty else {
                return .unkonw
            }
            
            if ["png", "jpg", "jpeg", "webp", "bmp", "tiff", "gif", "pcx", "tga", "exif", "fpx", "svg", "psd", "cdr", "pcd", "dxf", "ufo", "eps", "ai", "raw" ].contains(extensionName) {
                return .image
            }else if ["mov", "mp4", "avi", "wmv", "navi", "dv-avi", "divx", "asf", "rm", "rmvb"].contains(extensionName) {
                return .video
            }else if ["pdf"].contains(extensionName) {
                return .pdf
            }else {
                return .unkonw
            }
        }
    }
    
    public typealias Complete = ([FileValue]?) -> Void
    
    private let complete: Complete?
    
    public required init(complete: Complete?) {
        self.complete = complete
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UIDocumentPickerDelegate
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let urls = urls.filter({ $0.startAccessingSecurityScopedResource() })
        
        guard !urls.isEmpty else {
            complete?(nil)
            return
        }
        
        let fileValues = urls.map { (aUrl) -> FileValue in
            var file = FileValue()
            file.url = aUrl
            
            var error: NSError? = nil
            NSFileCoordinator().coordinate(readingItemAt: aUrl, error: &error) { (newUrl) in
                guard let fileDate = try? Data(contentsOf: newUrl) else { return }
                file.data = fileDate
            }
            
            return file
        }
        
        complete?(fileValues)
    }
    
}
