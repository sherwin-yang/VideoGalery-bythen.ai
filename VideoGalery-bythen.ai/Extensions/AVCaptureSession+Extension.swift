//
//  AVCaptureSession+Extension.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation
import AVKit

enum VideoRecordingError: String, Error {
    case deviceDoesNotSupportVideoRecording = "Device Doesn't Support Video Recording"
    case cameraAccessUnauthorized = "Camera Access Unauthorized"
    case failedToLayoutVideoPreview = "Failed to Layout Video Preview"
    case unableToStartRecording = "Project Failed to Start Recording"
}

extension AVCaptureSession {
    var movieFileOutput: AVCaptureMovieFileOutput? {
        let output = self.outputs.first as? AVCaptureMovieFileOutput
        
        return output
    }
    
    func setupVideoRecording() throws {
        try addVideoInput()
        try addMovieFileOutput()
        DispatchQueue.global().async { [weak self] in
            self?.startRunning()
        }
    }
    
    private func addVideoInput() throws {
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video),
              let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice),
              canAddInput(videoInput)
        else { throw VideoRecordingError.deviceDoesNotSupportVideoRecording }
        
        addInput(videoInput)
    }
    
    private func addMovieFileOutput() throws {
        let fileOutput = AVCaptureMovieFileOutput()
        if canAddOutput(fileOutput) { addOutput(fileOutput) }
        else { throw VideoRecordingError.deviceDoesNotSupportVideoRecording }
    }
}
