//
//  UploadedVideoListViewModel.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation
import Combine

final class UploadedVideoListViewModel: ObservableObject {
    private let getUploadedVideoDetail: () async throws -> [UploadedVideoDetail]
    private let deleteItem: (String) -> Void
    private let observeVideoUploading: () -> AnyPublisher<UploadVideoStatus, Never>
    private let cancelLastUploadVideo: () -> Void
    private var getUploadedVideoDetailTask: Task<(), Never>?
    
    @Published private(set) var uploadedVideoDetail: [UploadedVideoDetail] = []
    @Published private(set) var isUploadedVideoListViewHidden = true
    
    @Published private(set) var isLoadingIndicatorHidden = false
    @Published private(set) var isRetryButtonHidden = true
    
    var uploadVideoStatus = UploadVideoStatus.none
    
    init(
        getUploadedVideoDetail: @escaping () async throws -> [UploadedVideoDetail],
        deleteItem: @escaping (String) -> Void,
        observeVideoUploading: @escaping () -> AnyPublisher<UploadVideoStatus, Never>,
        cancelLastUploadVideo: @escaping () -> Void
    ) {
        self.getUploadedVideoDetail = getUploadedVideoDetail
        self.deleteItem = deleteItem
        self.observeVideoUploading = observeVideoUploading
        self.cancelLastUploadVideo = cancelLastUploadVideo
    }
    
    deinit {
        getUploadedVideoDetailTask?.cancel()
    }
    
    private var cancellable = Set<AnyCancellable>()
    func viewAppear() {
        loadGetUploadedVideoDetail()
        observeVideoUploading().sink { [weak self] in
            self?.uploadVideoStatus = $0
        }.store(in: &cancellable)
    }
    
    func retry() {
        isLoadingIndicatorHidden = false
        isRetryButtonHidden = true
        loadGetUploadedVideoDetail()
    }
    
    func delete(item: UploadedVideoDetail?) {
        guard let item else { return }
        deleteItem(item.publicId)
        uploadedVideoDetail.removeAll { $0 == item }
    }
    
    func cancelUploadVideo() {
        cancelLastUploadVideo()
    }
    
    private func loadGetUploadedVideoDetail() {
        getUploadedVideoDetailTask = Task { @MainActor [weak self] in
            do {
                let videoDetail = try await self?.getUploadedVideoDetail()
                self?.isUploadedVideoListViewHidden = false
                self?.uploadedVideoDetail = videoDetail ?? []
            } catch {
                self?.isRetryButtonHidden = false
            }
            self?.isLoadingIndicatorHidden = true
        }
    }
}

extension UploadedVideoListViewModel {
    static func make() -> Self {
        .init(getUploadedVideoDetail: UploadedVideoDetailProvider.make().get, 
              deleteItem: DeleteVideo.make().delete, 
              observeVideoUploading: UploadVideoStatusPublisher().observe, 
              cancelLastUploadVideo: VideoUploader.shared.cancel)
    }
}
