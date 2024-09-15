//
//  UploadVideoStatusPublisher.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/15/24.
//

import Foundation
import Combine

enum UploadVideoStatus {
    case none
    case uploading
    case success
    case failed
}

class UploadVideoStatusPublisher {
    
    private let statusPublisher = PassthroughSubject<UploadVideoStatus, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    func observe() -> AnyPublisher<UploadVideoStatus, Never> {
        NotificationCenter.default.publisher(for: .successUploadVideo)
            .merge(with: NotificationCenter.default.publisher(for: .failedUploadVideo))
            .sink { [weak self ] in
                guard let self else { return }
                if $0.name == .successUploadVideo {
                    statusPublisher.send(.success)
                } else if $0.name == .failedUploadVideo {
                    statusPublisher.send(.failed)
                } else if $0.name == .uploadingVideo {
                    statusPublisher.send(.uploading)
                }
            }
            .store(in: &cancellables)
        
        return statusPublisher.eraseToAnyPublisher()
    }
}
