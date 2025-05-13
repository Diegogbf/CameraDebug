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
    let session = AVCaptureSession()
    private let photoOutputHandler = PhotoOutputHandler()
    private let output = AVCapturePhotoOutput()
    private var deviceInput: AVCaptureDeviceInput?
    private var cameraPosition: AVCaptureDevice.Position = .back
    @Published var image: UIImage?

    func configure() {
        createInput(for: cameraPosition)

        if session.canAddOutput(output) {
            session.addOutput(output)
        }

        output.maxPhotoQualityPrioritization = .quality
        session.sessionPreset = AVCaptureSession.Preset.photo
        session.commitConfiguration()
        background { [weak self] in
            self?.session.startRunning()
        }
    }

    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutputHandler.completion = { [weak self] image in
            self?.image = image
            self?.background { [weak self] in
                self?.session.stopRunning()
            }
        }
        background { [weak self, photoOutputHandler] in
            self?.output.capturePhoto(with: settings, delegate: photoOutputHandler)
        }
    }

    func reset() {
        image = nil
        background { [weak self] in
            self?.session.startRunning()
        }
    }

    func flipCamera() {
        let newPosition: AVCaptureDevice.Position = cameraPosition == .back ? .front : .back
        cameraPosition = newPosition
        background { [weak self, ] in
            self?.createInput(for: newPosition)
            self?.session.commitConfiguration()
        }
    }

    func createInput(for position: AVCaptureDevice.Position) {
        session.beginConfiguration()
        if let deviceInput {
            session.removeInput(deviceInput)
        }

        if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: position),
           let input = try? AVCaptureDeviceInput(device: device) {
            if session.canAddInput(input) {
                session.addInput(input)
                deviceInput = input
            }
        }
    }

    func background(completion: @escaping () -> Void) {
        Task.detached {
            completion()
        }
    }
}

class PhotoOutputHandler: NSObject, AVCapturePhotoCaptureDelegate {
    var completion: ((UIImage) -> Void)?

    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        completion?(image)
    }
}
