//
//  ViewCaptureViewModel.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/12/25.
//

import SwiftUI
import AVFoundation

final class VideoCaptureViewModel: ObservableObject {
    @Published var isRecording: Bool = false {}
    @Published var image: UIImage?
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private var deviceInput: AVCaptureDeviceInput?
    private var cameraPosition: AVCaptureDevice.Position = .back
    private let videoOutputHandler = VideoOutputHandler()

    func configure() {
        createInput(for: cameraPosition)

        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(
                videoOutputHandler,
                queue: .global(qos: .userInitiated)
            )
        }
        videoOutput.connections.first?.videoRotationAngle = 90
        session.commitConfiguration()
        background { [weak self] in
            self?.session.startRunning()
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

    func flipCamera() {
        let newPosition: AVCaptureDevice.Position = cameraPosition == .back ? .front : .back
        cameraPosition = newPosition
        background { [weak self, ] in
            self?.createInput(for: newPosition)
            self?.session.commitConfiguration()
        }
    }

    func captureFrame() {
        if isRecording {
            isRecording = false
            videoOutputHandler.completion = { [self] image in
                Task {
                    await MainActor.run {
                        self.image = image
                    }
                }
            }
            background { [weak self] in
                self?.session.stopRunning()
            }
        } else {
            isRecording = true
            image = nil
            background { [weak self] in
                self?.session.startRunning()
            }
        }
    }

    func recordButtonTapped() {
        isRecording.toggle()
        if isRecording {
            image = nil
            background { [weak self] in
                self?.session.startRunning()
            }
        } else {
            background { [weak self] in
                self?.session.stopRunning()
            }
        }
    }

    func background(completion: @escaping () -> Void) {
        Task.detached {
            completion()
        }
    }
}

class VideoOutputHandler: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var completion: ((UIImage) -> Void)?

    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

        if connection.isVideoRotationAngleSupported(rotationAngle) {
            connection.videoRotationAngle = rotationAngle
        }
    
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            completion?(UIImage(cgImage: cgImage))
        }
    }

    var rotationAngle: CGFloat {
        let orientation = UIDevice.current.orientation
        switch orientation {
        case UIDeviceOrientation.portraitUpsideDown:
            return 270
        case UIDeviceOrientation.landscapeLeft:
            return 0
        case UIDeviceOrientation.landscapeRight:
            return 180
        default:
            return  90
        }
    }
}
