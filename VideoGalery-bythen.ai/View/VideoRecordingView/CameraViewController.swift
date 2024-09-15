//
//  CameraViewController.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import UIKit
import SwiftUI
import AVFoundation

protocol CameraViewControllerDelegate {
    func didStartRecording(isSuccess: Bool)
    func didStopRecording()
    func didFinishedRecording(filePath: URL)
    func didThrowError(_ error: Error)
}

class CameraViewController: UIViewController {
    
    private let captureSession = AVCaptureSession()
    private var previewLayer: AVCaptureVideoPreviewLayer?
    
    var cameraViewDelegate: CameraViewControllerDelegate?
    
    init(cameraViewDelegate: CameraViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.cameraViewDelegate = cameraViewDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCaptureSession()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard let previewLayer = previewLayer else { return }
        previewLayer.frame = view.layer.bounds
    }
    
    private func setupCaptureSession() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            do {
                try captureSession.setupVideoRecording()
                configureVideoPreview()
            } catch {
                cameraViewDelegate?.didThrowError(error)
            }
        case .denied:
            cameraViewDelegate?.didThrowError(VideoRecordingError.cameraAccessUnauthorized)
        default: break;
        }
    }
    
    private func configureVideoPreview() {
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        if let previewLayer = previewLayer {
            previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(previewLayer)
        } else {
            cameraViewDelegate?.didThrowError(VideoRecordingError.failedToLayoutVideoPreview)
        }
    }
    
    func startRecording() {
        guard let output = captureSession.movieFileOutput,
              let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        else {
            cameraViewDelegate?.didStartRecording(isSuccess: false)
            cameraViewDelegate?.didThrowError(VideoRecordingError.unableToStartRecording)
            return
        }
        
        let fileName = "Recording_" + UUID().uuidString
        let filePath = directoryPath
            .appendingPathComponent(fileName)
            .appendingPathExtension("mp4")
        
        output.startRecording(to: filePath, recordingDelegate: self)
        cameraViewDelegate?.didStartRecording(isSuccess: true)
    }
    
    func stopRecording() {
        captureSession.movieFileOutput?.stopRecording()
        cameraViewDelegate?.didStopRecording()
    }
}

extension CameraViewController: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection], 
        error: (any Error)?
    ) {
        cameraViewDelegate?.didFinishedRecording(filePath: outputFileURL)
    }
}

struct CameraView: UIViewControllerRepresentable {
    
    @Binding var recordingState: VideoRecordState
    @Binding var videoRecordingResultPath: IdentifiableURL?
    @Binding var isPresentingAlert: Bool
    @Binding var alertMessage: String?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(cameraView: self)
    }
    
    func makeUIViewController(context: Context) -> CameraViewController {
        let cameraVc = CameraViewController(cameraViewDelegate: context.coordinator)
        return cameraVc
    }
    
    func updateUIViewController(_ uiViewController: CameraViewController, context: Context) {
        switch recordingState {
        case .requestingStart: uiViewController.startRecording()
        case .requestingStop: uiViewController.stopRecording()
        default: break
        }
    }
    
    struct Coordinator: CameraViewControllerDelegate {
        
        private let cameraView: CameraView
        
        init(cameraView: CameraView) {
            self.cameraView = cameraView
        }
        
        func didStartRecording(isSuccess: Bool) {
            DispatchQueue.main.async {
                cameraView.recordingState = isSuccess ? .recording : .idle
            }
        }
        
        func didStopRecording() {
            DispatchQueue.main.async {
                cameraView.recordingState = .idle
            }
        }
        
        func didFinishedRecording(filePath: URL) {
            DispatchQueue.main.async {
                cameraView.videoRecordingResultPath = .init(url: filePath)
            }
        }
        
        func didThrowError(_ error: Error) {
            DispatchQueue.main.async {
                cameraView.alertMessage = 
                error is VideoRecordingError
                ? { (error as? VideoRecordingError)?.rawValue }()
                : "\(error)"
                
                cameraView.isPresentingAlert = true
            }
        }
    }
}
