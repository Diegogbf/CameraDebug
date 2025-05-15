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
    @Published var displayError: Bool = false
    var contextError: ContextError? {
        didSet {
            displayError = contextError != nil
        }
    }

    let cameraHandler = CameraHandler()

    @MainActor
    func configure() async {
        do {
            try await cameraHandler.configure()
        } catch CameraHandler.CameraError.accessDenied {
            contextError = .cameraDenied
        } catch {
            contextError = .unexpected
        }
    }

    func flipCamera() async {
        await cameraHandler.flipCamera()
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

    func stop() async {
        await cameraHandler.stop()
    }

    func recordButtonTapped() {
        isRecording.toggle()
    }
}
