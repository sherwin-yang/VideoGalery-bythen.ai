//
//  UploadedVideoListView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/12/24.
//

import SwiftUI

struct UploadedVideoListView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel = UploadedVideoListViewModel.make()
    
    @State private var toPreviewSelectedItem: UploadedVideoDetail?
    @State private var isShowingRecordingScreen = false
    @State private var toDeleteSelectedItem: UploadedVideoDetail?
    @State private var didSelectedItemToDelete = false
    @State private var isDeletingMode = false
    
    @State private var showWarningDeletingLastVideoRecording = false
    
    private var toDeleteItemPublicId: String {
        toDeleteSelectedItem?.publicId ?? "(non existing public id)"
    }
    
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
                    toPreviewVideoSelection: $toPreviewSelectedItem,
                    toDeleteVideoSelection: $toDeleteSelectedItem,
                    didSelectedItemToDelete: $didSelectedItemToDelete,
                    isDeletingMode: $isDeletingMode
                )
                .isHidden(viewModel.isUploadedVideoListViewHidden)
            }
            .onAppear(perform: viewModel.viewAppear)
            .fullScreenCover(item: $toPreviewSelectedItem) {
                VideoPreviewView(videoURL: $0.secureUrl)
            }
            .fullScreenCover(
                isPresented: $isShowingRecordingScreen,
                onDismiss: { isShowingRecordingScreen = false },
                content: { VideoRecordingView(isPresenting: $isShowingRecordingScreen) }
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: { isDeletingMode.toggle() },
                        label: {
                            if isDeletingMode {
                                Text("Cancel")
                            } else {
                                Text("Delete")
                                    .foregroundStyle(.red)
                            }
                        }
                    )
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(
                        action: {
                            if viewModel.uploadVideoStatus == .uploading || viewModel.uploadVideoStatus == .failed {
                                showWarningDeletingLastVideoRecording = true
                            } else {
                                isShowingRecordingScreen = true
                            }
                        },
                        label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    )
                }
            }
            .alert("Confirm Deleting \(toDeleteItemPublicId)?", isPresented: $didSelectedItemToDelete) {
                Button("Cancel") { dismiss() }
                Button("Confirm") {
                    viewModel.delete(item: toDeleteSelectedItem)
                    dismiss()
                }
                .foregroundColor(.red)
            }
            .alert(
                "Do you wish to DELETE/CANCEL your last uploading video and continue to record NEW video",
                isPresented: $showWarningDeletingLastVideoRecording)
            {
                Button("No") { dismiss() }
                Button("Yes") {
                    isShowingRecordingScreen = true
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    UploadedVideoListView()
}
