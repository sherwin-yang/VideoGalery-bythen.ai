//
//  UploadedVideoDetailListView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import SwiftUI

struct UploadedVideoDetailListView: View {
    var videoDetails: [UploadedVideoDetail]
    @Binding var toPreviewVideoSelection: UploadedVideoDetail?
    @Binding var toDeleteVideoSelection: UploadedVideoDetail?
    @Binding var didSelectedItemToDelete: Bool
    @Binding var isDeletingMode: Bool
    
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
                    
                    isDeletingMode
                    ? Image(systemName: "trash.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.red)
                    : Image(systemName: "play.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(Color(.label))
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .cardBackground()
                .onTapGesture {
                    if isDeletingMode {
                        toDeleteVideoSelection = videoDetails
                        didSelectedItemToDelete = true
                    } else {
                        toPreviewVideoSelection = videoDetails
                    }
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

#Preview {
    @State var toPreviewVideoSelection: UploadedVideoDetail?
    @State var toDeleteVideoSelection: UploadedVideoDetail?
    @State var didSelectedItemToDelete = Bool.random()
    @State var isDeletingMode = Bool.random()
    return UploadedVideoDetailListView(videoDetails: [], 
                                       toPreviewVideoSelection: $toPreviewVideoSelection, 
                                       toDeleteVideoSelection: $toDeleteVideoSelection, 
                                       didSelectedItemToDelete: $didSelectedItemToDelete,
                                       isDeletingMode: $isDeletingMode)
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
