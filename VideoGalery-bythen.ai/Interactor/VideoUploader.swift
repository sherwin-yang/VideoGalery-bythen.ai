//
//  VideoUploader.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation
import Combine

extension Notification.Name {
    static let successUploadVideo = Notification.Name("successUploadVideo")
    static let failedUploadVideo = Notification.Name("failedUploadVideo")
}

struct VideoUploader {
    static var shared = VideoUploader(post: PostVideo.make().post)
    
    private let post: (URL, @escaping (PostVideo.isSuccess) -> Void) -> Void
    
    init(post: @escaping (URL, @escaping (PostVideo.isSuccess) -> Void) -> Void) {
        self.post = post
    }
    
    func upload(filePath: URL) {
        post(filePath) { success in
            if success {
                NotificationCenter.default.post(name: .successUploadVideo, object: nil, userInfo: [:])
                _ = try? FileManager.default.removeItem(at: filePath)
            } else {
                NotificationCenter.default.post(name: .failedUploadVideo, object: nil, userInfo: [:])
            }
        }
    }
}
