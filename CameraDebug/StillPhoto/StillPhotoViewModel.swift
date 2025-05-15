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
    @Published var displayError: Bool = false
    let cameraHandler = CameraHandler()
    var contextError: ContextError? {
        didSet {
            displayError = contextError != nil
        }
    }

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
