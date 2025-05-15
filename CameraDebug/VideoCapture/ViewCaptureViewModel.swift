//
//  ViewCaptureViewModel.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/12/25.
//

import AVFoundation
import SwiftUI

final class VideoCaptureViewModel: ObservableObject {
    @Published var isRecording: Bool = false
    @Published var image: UIImage?
    let cameraHandler = CameraHandler()

    func configure() {
        cameraHandler.configure()
        cameraHandler.start()
    }

    func flipCamera() {
        cameraHandler.flipCamera()
    }

    func captureFrame() {
        Task {
            do {
                let image = try await cameraHandler.captureFrame()
                await MainActor.run {
                    self.image = image
                }
            } catch { }
        }
    }

    func stop() {
        cameraHandler.stop()
    }

    func recordButtonTapped() {
        isRecording.toggle()
    }
}
