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
    @Published var sample: PhotoSample?
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
        for await (image, position) in cameraHandler.cameraStream {
            Task { @MainActor in
                sample = .init(
                    type: .stillPhoto,
                    position: position,
                    image: image
                )
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

    func stop() async {
        await cameraHandler.stop()
    }

    func flipCamera() async {
        await cameraHandler.flipCamera()
    }

    func captureFrame() {
        cameraHandler.capturePhoto()
    }
}
