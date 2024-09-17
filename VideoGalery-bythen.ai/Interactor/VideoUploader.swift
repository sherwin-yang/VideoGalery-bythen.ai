//
//  VideoUploader.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation
import Combine

extension Notification.Name {
    static let uploadingVideo = Notification.Name("uploadingVideo")
    static let successUploadVideo = Notification.Name("successUploadVideo")
    static let failedUploadVideo = Notification.Name("failedUploadVideo")
    static let cancelUploadVideo = Notification.Name("cancelUploadVideo")
}

class VideoUploader {
    static var shared = VideoUploader(videoPoster: PostVideo.make())
    
    private let videoPoster: PostVideoProtocol
    private var filePath: URL?
    
    init(videoPoster: PostVideoProtocol) {
        self.videoPoster = videoPoster
    }
    
    func upload(filePath: URL) {
        self.filePath = filePath
        NotificationCenter.default.post(name: .uploadingVideo, object: nil, userInfo: [:])
        videoPoster.post(filePath: filePath) { success in
            if success {
                NotificationCenter.default.post(name: .successUploadVideo, object: nil, userInfo: [:])
                try? FileManager.default.removeItem(at: filePath)
            } else {
                NotificationCenter.default.post(name: .failedUploadVideo, object: nil, userInfo: [:])
            }
        }
    }
    
    func retry() {
        guard let filePath else { return }
        upload(filePath: filePath)
    }
    
    func cancel() {
        videoPoster.cancelUploadTask()
        if let filePath { try? FileManager.default.removeItem(at: filePath) }
    }
}
