//
//  UploadVideoPreviewViewModel.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation

struct UploadVideoPreviewViewModel {
    private let upload: (URL) -> Void
    
    init(upload: @escaping (URL) -> Void) {
        self.upload = upload
    }
    
    func uploadVideo(filePath: URL) {
        upload(filePath)
    }
}

extension UploadVideoPreviewViewModel {
    static func make() -> UploadVideoPreviewViewModel {
        .init(upload: VideoUploader.shared.upload)
    }
}
