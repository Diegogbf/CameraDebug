//
//  StillPhotoViewModel.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI
import UIKit
import AVFoundation

final class StillPhotoViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var image: UIImage?
    let cameraHandler = CameraHandler()

    init() {
        Task {
            await handleCameraStream()
        }
    }

    func handleCameraStream() async {
        for await imageData in cameraHandler.cameraStream {
            Task { @MainActor in
                image = imageData
            }
        }
    }

    func configure() {
        cameraHandler.configure()
    }

    func stop() {
        cameraHandler.stop()
    }

    func flipCamera() {
        cameraHandler.flipCamera()
    }

    func captureFrame() {
        cameraHandler.capturePhoto()
    }
}
