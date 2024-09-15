//
//  PostVideo.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation
import Alamofire

struct MultipartFormDataURLRequest {
    let url: URL
    let header: [String: String]
    let formData: [String: Data]
}

struct VideoMultipartFormData {
    let key: String
    let value: Data
    let fileName: String
    let contentType: String
}

protocol PostVideoProtocol {
    typealias isSuccess = Bool
    
    func post(filePath: URL, onComplete: @escaping (isSuccess) -> Void)
    func cancelUploadTask()
}

class PostVideo: PostVideoProtocol {
    typealias CompletionBlock = (Data?) -> Void
    
    private let getAuthKey: () async throws -> ApiKey
    private let uploadVideo: (MultipartFormDataURLRequest, VideoMultipartFormData, @escaping CompletionBlock) -> Void
    
    init(
        getAuthKey: @escaping () async throws -> ApiKey,
        uploadVideo: @escaping (MultipartFormDataURLRequest, VideoMultipartFormData, @escaping CompletionBlock) -> Void
    ) {
        self.getAuthKey = getAuthKey
        self.uploadVideo = uploadVideo
    }
    
    private var uploadVideoTask: Task<(), Never>?
    
    func post(filePath: URL, onComplete: @escaping (isSuccess) -> Void) {
        uploadVideoTask = Task {
            guard let authKey = try? await getAuthKey(),
                  let fileData = try? Data(contentsOf: filePath),
                  let intApiKey = Int(authKey.apiKey),
                  let encodedAuth = "\(intApiKey):\(authKey.apiSecret)".data(using: .utf8)?.base64EncodedString(),
                  let url = try? CloudinaryURLBuilder(path: "video/upload").build(),
                  let ml_default_data = "ml_default".data(using: .utf8),
                  let public_id_data = UUID().uuidString.data(using: .utf8),
                  let api_key_data = authKey.apiKey.data(using: .utf8)
            else { onComplete(false); return }
            
            let publicId = UUID().uuidString
            
            uploadVideo(
                .init(
                    url: url, header: ["Authorization": "Basic \(encodedAuth)"],
                    formData: [
                        "upload_preset": ml_default_data,
                        "public_id": public_id_data,
                        "api_key": api_key_data
                    ]
                ),
                .init(key: "file", value: fileData, fileName: "\(publicId).MOV", contentType: "video/mp4"),
                { onComplete($0 != nil) }
            )
        }
    }
    
    func cancelUploadTask() {
        uploadVideoTask?.cancel()
    }
}

extension PostVideo {
    static func make() -> PostVideo {
        .init(
            getAuthKey: ApiKeyManager.make().get,
            uploadVideo: { multipartFormDataURLRequest, videoMultipartFormData, completionBlock in
                AF.upload(
                    multipartFormData: { multipartFormData in
                        multipartFormData.append(videoMultipartFormData.value,
                                                 withName: videoMultipartFormData.key,
                                                 fileName: videoMultipartFormData.fileName,
                                                 mimeType: videoMultipartFormData.contentType)
                        multipartFormDataURLRequest.formData.forEach { (key, value) in
                            multipartFormData.append(value, withName: key)
                        }
                    },
                    to: multipartFormDataURLRequest.url,
                    headers: .init(multipartFormDataURLRequest.header)
                ).response { completionBlock($0.data) }
            }
        )
    }
}
