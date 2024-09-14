//
//  UploadedVideoDetailListView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import SwiftUI

struct UploadedVideoDetailListView: View {
    var videoDetails: [UploadedVideoDetail]
    @Binding var videoSelection: UploadedVideoDetail?
    
    var body: some View {
        List {
            ForEach(videoDetails) { videoDetails in
                HStack {
                    VStack(alignment: .leading) {
                        Text(videoDetails.publicId)
                            .padding(.bottom, 4)
                        Text(videoDetails.createdAt)
                            .foregroundStyle(.gray)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .cardBackground()
                .onTapGesture {
                    videoSelection = videoDetails
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    @State var videoSelection: UploadedVideoDetail?
    return UploadedVideoDetailListView(videoDetails: [], videoSelection: $videoSelection)
}

private struct CardBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.background)
            .cornerRadius(value: 16)
            .shadow(color: .gray.opacity(0.5), radius: 4)
    }
}

private extension View {
    func cardBackground() -> some View {
        modifier(CardBackground())
    }
}
