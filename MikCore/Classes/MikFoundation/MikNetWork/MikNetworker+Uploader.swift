//
//  MikUploaderUtils.swift
//  MikFoundation
//
//  Created by m7 on 2021/9/14.
//

import Foundation
import Alamofire
import HandyJSON


public extension MikNetworker {
    
    typealias MikUploadRequest = UploadRequest
    
    ///上传进度回调
    typealias UploadProgressCallback = Request.ProgressHandler
    
    /// 图片上传结果回调
    typealias UploadFilesResultCallback = (Result<[UploadResult]?, MikError>) -> Void
        
    struct UploadResult {
        public var fileType: FileType?
        public var url: String?
        public var fileName: String?
        public var index: Int?
        public var contentDataId: String?
    }
    
}

// MARK: - Private
fileprivate extension MikNetworker {
    
    /// 文件流上传
    /// - Parameters:
    ///   - url: 上传地址
    ///   - progressHandler: 上传进度回调
    ///   - result: 上传结果回调
    @discardableResult
    static private func upload(url: String,
                               files: [UploadFileModel],
                               params: [AnyHashable: Any]?,
                               progress: UploadProgressCallback?,
                               result: ((Result<[AnyHashable: Any]?, MikError>) -> Void)?) -> MikUploadRequest? {
        let headers: HTTPHeaders? = MikNetworkManager.shared.headers
        
        let requestData = MultipartFormData()
        
        for (index, file) in files.enumerated() {
            if let data = file.data {
                let fileName: String = file.fileName ?? UploadFileModel.randomFileName(fileType: file.fileType, index: index)
                requestData.append(data, withName: file.fileType.withName, fileName: fileName, mimeType: file.fileType.mimeType)
            }
        }
        
        if let params = params, let paramsData = try? JSONSerialization.data(withJSONObject: params) {
            requestData.append(paramsData, withName: "contentRequest", fileName: "blob", mimeType: "application/json")
        }
        
        let uploadRequest = AF.upload(multipartFormData: requestData, to: url, headers: headers)
        
        uploadRequest.uploadProgress { (p) in
            MikPrint("upload.... \(p.completedUnitCount) / \(p.totalUnitCount)")
            progress?(p)
        }
        
        uploadRequest.responseJSON { (response) in
            switch response.result {
            case .success(_):
                result?(.success(response.value as? [AnyHashable: Any]))
                
            case .failure(let error):
                if let code = error.responseCode, MikNetworkManager.shared.errorCode.contains(code) {
                    MikNetworkManager.shared.takeErrorCodeBlock?(code)
                }
                                                
                result?(.failure(.requestError(info: {
                    var info = MikResponseErrorInfoModel(message: error.localizedDescription)
                    info.code = error.responseCode
                    return info
                }())))
            }
        }
        
        return uploadRequest
    }
        
    /// 解析上传图片返回结果
    /// - Parameter response: 上传结果
    /// - Returns: 图片地址集
    private static func parseUploadResponse(_ response: [AnyHashable: Any]?, orginFiles: [UploadFileModel]) -> [UploadResult]? {
        guard let response = response, let data = response["data"] as? [AnyHashable: Any], let uploadedFiles = data["uploadedFiles"] as? [[AnyHashable: Any]], !uploadedFiles.isEmpty else {
            return nil
        }
        
                
        let uploadRss = uploadedFiles.compactMap({ (ele) -> UploadResult? in
            guard let url = ele["url"] as? String, !url.isEmpty else { return nil }
            
            let fileName = ele["fileName"] as? String
            let index = ele["index"] as? Int
            let contentDataId = ele["contentDataId"] as? String
            let fileType = orginFiles.first(where: { $0.fileName?.lowercased() == fileName?.lowercased() })?.fileType
            
            return UploadResult(fileType: fileType, url: url, fileName: fileName, index: index, contentDataId: contentDataId)
        })
        
        return uploadRss.sorted(by: { ($0.index ?? 0) < ($1.index ?? 0)  })
    }
    
}

// MARK: - Public
public extension MikNetworker {
    
    /// 上传文件
    /// - Parameters:
    ///   - withName: 二进制参数名
    ///   - dataValues: 上传相关参数
    ///   - progressHandler: 上传进度回调
    ///   - result: 上传结果回调
    @discardableResult
    static func upload(url: String,
                       userId: String?,
                       files: [UploadFileModel],
                       progress: UploadProgressCallback?,
                       result: UploadFilesResultCallback?) -> MikUploadRequest? {
        // 参数
        var params = [String: Any]()
        params["clientId"] = "mobile"
        params["sourceId"] = "0"
        params["clientName"] = "iOS"
        params["sourceType"] = "1"
        params["byPassScreening"] = true // 开启鉴黄
        params["userId"] = userId
                
        return Self.upload(url: url, files: files, params: params, progress: progress) { (rs) in
            switch rs {
            case .success(let res):
                result?(.success(self.parseUploadResponse(res, orginFiles: files)))
            case .failure(let err):
                result?(.failure(err))
            }
        }
    }
    
    /// 上传图片
    /// - Parameter:
    ///   - images: 图片集
    ///   - isCompress: 是否需要压缩
    ///   - progress: 上传进度
    ///   - success: 成功回调
    ///   - failure: 失败回调
    @discardableResult
    static func uploadImages(url: String,
                             userId: String?,
                             images: [UIImage],
                             isCompress: Bool = true,
                             progress: UploadProgressCallback? = nil,
                             result: UploadFilesResultCallback?) -> MikUploadRequest? {
        var files = [UploadFileModel]()
        for (index, image) in images.enumerated() {
            let model = UploadFileModel()
            if isCompress {
                model.data = image.mik.compressToBytes()
            } else {
                model.data = image.jpegData(compressionQuality: 1)
            }
            model.fileType = .image(suffix: "jpeg")
            model.fileName = UploadFileModel.randomFileName(fileType: model.fileType, index: index)
            files.append(model)
        }
        
        return Self.upload(url: url, userId: userId, files: files, progress: progress, result: result)
    }
    
    /// 上传'PDF'文件
    /// - Parameters:
    ///   - videoDataValues: 包装的视频信息
    ///   - progress: 上传进度
    ///   - success: 上传成功回调
    ///   - failure: 上传失败回调
    @discardableResult
    static func uploadPDFs(url: String,
                           userId: String?,
                           pdfUrls: [URL],
                           progress: UploadProgressCallback? = nil,
                           result: UploadFilesResultCallback?) -> MikUploadRequest? {
        let fileDatas = pdfUrls.compactMap({ try? Data(contentsOf: $0) })
        
        guard !fileDatas.isEmpty else {
            // 资源不存在
            result?(.failure(MikError.requestError(info: {
                var aErrorInfo = MikResponseErrorInfoModel()
                aErrorInfo.message = "The pdf does not exist"
                return aErrorInfo
            }())))
            return nil
        }
        
        return Self.uploadPDFs(url: url, userId: userId, pdfDatas: fileDatas, progress: progress, result: result)
    }
    
    /// 上传'PDF'文件
    /// - Parameters:
    ///   - videoDataValues: 包装的视频信息
    ///   - progress: 上传进度
    ///   - success: 上传成功回调
    ///   - failure: 上传失败回调
    @discardableResult
    static func uploadPDFs(url: String,
                           userId: String?,
                           pdfDatas: [Data],
                           progress: UploadProgressCallback? = nil,
                           result: UploadFilesResultCallback?) -> MikUploadRequest? {
        var files = [UploadFileModel]()
        for (index, data) in pdfDatas.enumerated() {
            let model = UploadFileModel()
            model.data = data
            model.fileType = .pdf(suffix: "pdf")
            model.fileName = UploadFileModel.randomFileName(fileType: model.fileType, index: index)
            files.append(model)
        }
        
        return Self.upload(url: url, userId: userId, files: files, progress: progress, result: result)
    }
    
}
