//
//  UploadVideoPreview.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import SwiftUI

struct UploadVideoPreview: View {
    @Environment(\.dismiss) private var dismiss
    private let videoURL: URL
    
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    var body: some View {
        NavigationStack {
            VideoPlayerView(videoURL: videoURL)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") { dismiss() }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Upload") {
                            print("@@@ upload")
                        }
                    }
                }
        }
    }
}

#Preview {
    UploadVideoPreview(videoURL: URL(string: "any_url")!)
}
