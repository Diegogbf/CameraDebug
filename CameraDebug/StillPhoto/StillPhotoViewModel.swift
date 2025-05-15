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

    func configure() {
        cameraHandler.configure()
    }

    func flipCamera() {
        cameraHandler.flipCamera()
    }

    func captureFrame() {
        cameraHandler.capturePhoto()
        cameraHandler.stop()
    }

    func resetCapture() {
        image = nil
        cameraHandler.start()
    }
}
