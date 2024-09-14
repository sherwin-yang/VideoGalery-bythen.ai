//
//  VideoPreviewView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import SwiftUI

struct VideoPreviewView: View {
    private let videoURL: URL
    
    init(videoURL: URL) {
        self.videoURL = videoURL
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                CloseButton()
                    .padding(.trailing, 16)
            }
            .padding(.top, 10)
            VideoPlayerView(videoURL: videoURL)
                .padding([.vertical], 10)
        }
    }
}

#Preview {
    VideoPreviewView(videoURL: URL(string: "any_url")!)
}
