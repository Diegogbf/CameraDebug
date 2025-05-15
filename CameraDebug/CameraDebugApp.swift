//
//  CameraDebugApp.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI

@main
struct CameraDebugApp: App {
    @StateObject private var stillPhotoViewModel = StillPhotoViewModel()
    @StateObject private var videoFrameViewModel = VideoCaptureViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                StillPhotoView(viewModel: stillPhotoViewModel)
                    .navigationDestination(for: PhotoSample.self) { sample in
                        VStack {
                            switch sample.type {
                            case .stillPhoto:
                                VideoCaptureView(viewModel: videoFrameViewModel)
                            case .videoFrame:
                                ResultsView(
                                    stillPhotoSample: stillPhotoViewModel.sample,
                                    videoFrameSample: videoFrameViewModel.sample
                                )
                            }
                        }
                    }
            }
        }
    }
}
