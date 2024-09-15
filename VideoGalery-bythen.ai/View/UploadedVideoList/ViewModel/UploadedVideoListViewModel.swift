//
//  UploadedVideoListViewModel.swift
//  VideoGalery-bythen.ai
//
//  Created by Sherwin Yang on 9/14/24.
//

import Foundation

final class UploadedVideoListViewModel: ObservableObject {
    private let getUploadedVideoDetail: () async throws -> [UploadedVideoDetail]
    private let deleteItem: (String) -> Void
    private var getUploadedVideoDetailTask: Task<(), Never>?
    
    @Published private(set) var uploadedVideoDetail: [UploadedVideoDetail] = []
    @Published private(set) var isUploadedVideoListViewHidden = true
    
    @Published private(set) var isLoadingIndicatorHidden = false
    @Published private(set) var isRetryButtonHidden = true
    
    init(
        getUploadedVideoDetail: @escaping () async throws -> [UploadedVideoDetail],
        deleteItem: @escaping (String) -> Void
    ) {
        self.getUploadedVideoDetail = getUploadedVideoDetail
        self.deleteItem = deleteItem
    }
    
    deinit {
        getUploadedVideoDetailTask?.cancel()
    }
    
    func viewAppear() {
        loadGetUploadedVideoDetail()
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
              deleteItem: DeleteVideo.make().delete)
    }
}
