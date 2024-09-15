//
//  UploadVideoPreviewView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import SwiftUI

struct UploadVideoPreviewView: View {
    @Environment(\.dismiss) private var dismiss
    private var viewModel = UploadVideoPreviewViewModel.make()
    
    @Binding var isPresentingVideoRecordingView: Bool
    let videoURL: URL
    
    public init(isPresentingVideoRecordingView: Binding<Bool>, videoURL: URL) {
        self._isPresentingVideoRecordingView = isPresentingVideoRecordingView
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
                            viewModel.uploadVideo(filePath: videoURL)
                            dismiss()
                            isPresentingVideoRecordingView = false
                        }
                    }
                }
        }
    }
}

#Preview {
    @State var isPresentingVideoRecordingView = true
    return UploadVideoPreviewView(isPresentingVideoRecordingView: $isPresentingVideoRecordingView, videoURL: URL(string: "any_url")!)
}
