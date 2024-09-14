//
//  VideoPreviewView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import SwiftUI
import AVKit

struct VideoPreviewView: View {
    
    @State private var isPlayButtonHidden = false
    @Environment(\.dismiss) private var dismiss
    private let player: AVPlayer
    
    init(videoURL: URL) {
        player = AVPlayer(url: videoURL)
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(
                    action: { dismiss() },
                    label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(Color(UIColor.secondaryLabel))
                    }
                )
                .padding(.trailing, 16)
            }
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
}


#Preview {
    VideoPreviewView(videoURL: URL(string: "any_url")!)
}

