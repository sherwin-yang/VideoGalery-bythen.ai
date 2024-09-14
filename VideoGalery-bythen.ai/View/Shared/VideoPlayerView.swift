//
//  VideoPlayerView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @State private var isPlayButtonHidden = false
    private let player: AVPlayer
    
    init(videoURL: URL) {
        player = AVPlayer(url: videoURL)
    }
    
    var body: some View {
        ZStack {
            VideoPlayer(player: player)
                .isHidden(!isPlayButtonHidden)
            
            Button(
                action: {
                    player.play()
                    isPlayButtonHidden = true
                },
                label: {
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(.gray)
                }
            )
            .isHidden(isPlayButtonHidden)
        }
    }
}

#Preview {
    VideoPlayerView(videoURL: URL(string: "any_url")!)
}
