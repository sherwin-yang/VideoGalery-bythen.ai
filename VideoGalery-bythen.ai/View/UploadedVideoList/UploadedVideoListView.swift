//
//  UploadedVideoListView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import SwiftUI

struct UploadedVideoListView: View {
    @ObservedObject private var viewModel = UploadedVideoListViewModel.make()
    @State private var selectedItem: UploadedVideoDetail?
    @State private var isShowingRecordingScreen = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                ProgressView()
                    .progressViewStyle(.automatic)
                    .isHidden(viewModel.isLoadingIndicatorHidden)
                
                Button(
                    action: viewModel.retry,
                    label: {
                        Text("Retry")
                            .foregroundStyle(.red)
                            .bold()
                    }
                )
                .buttonStyle(BorderedButtonStyle())
                .isHidden(viewModel.isRetryButtonHidden)
                
                UploadedVideoDetailListView(
                    videoDetails: viewModel.uploadedVideoDetail,
                    videoSelection: $selectedItem
                )
                .isHidden(viewModel.isUploadedVideoListViewHidden)
            }
            .onAppear(perform: viewModel.viewAppear)
            .fullScreenCover(item: $selectedItem) {
                VideoPreviewView(videoURL: $0.secureUrl)
            }
            .fullScreenCover(
                isPresented: $isShowingRecordingScreen,
                onDismiss: { isShowingRecordingScreen = false },
                content: { VideoRecordingView(isPresenting: $isShowingRecordingScreen) }
            )
            .toolbar {
                Button(
                    action: { isShowingRecordingScreen = true },
                    label: {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 20, height: 20)
                    }
                )
            }
        }
    }
}

#Preview {
    UploadedVideoListView()
}
