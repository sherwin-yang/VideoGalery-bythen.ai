//
//  VideoRecordingView.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import SwiftUI

struct IdentifiableURL: Identifiable {
    let id = UUID()
    let url: URL
}

enum VideoRecordState {
    case idle
    case requestingStart
    case recording
    case requestingStop
}

struct VideoRecordingView: View {
    @State private var recordingState: VideoRecordState = .idle
    @State private var videoRecordingResultPath: IdentifiableURL?
    @State private var isPresentingAlert = false
    @State private var alertMessage: String?
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isPresenting: Bool
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                CloseButton()
                    .padding(.trailing, 16)
            }
            .padding(.top, 10)
            
            CameraView(
                recordingState: $recordingState,
                videoRecordingResultPath: $videoRecordingResultPath,
                isPresentingAlert: $isPresentingAlert,
                alertMessage: $alertMessage
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .cornerRadius(value: 16)
            .padding([.vertical], 10)
            
            Button(
                action: {
                    switch recordingState {
                    case .idle: recordingState = .requestingStart
                    case .recording: recordingState = .requestingStop
                    default: break
                    }
                },
                label: {
                    Image(systemName: recordingState == .recording ? "stop.circle" : "record.circle")
                        .resizable()
                        .foregroundStyle(recordingState == .recording ? .red : .gray)
                        .frame(width: 60, height: 60)
                }
            )
        }
        .fullScreenCover(item: $videoRecordingResultPath) {
            UploadVideoPreviewView(isPresentingVideoRecordingView: $isPresenting, videoURL: $0.url)
        }
        .alert(alertMessage ?? "", isPresented: $isPresentingAlert) {
            Button("Dismiss") { dismiss() }
        }
    }
}

#Preview {
    @State var isPresenting = true
    return VideoRecordingView(isPresenting: $isPresenting)
}

