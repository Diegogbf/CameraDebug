//
//  ViewCaptureViewModel.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/12/25.
//

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
        cameraHandler.shouldNotifyVideoFrame = true
        cameraHandler.shouldNotifyVideoFrame = false
    }

    func recordButtonTapped() {
        isRecording.toggle()
    }
}
