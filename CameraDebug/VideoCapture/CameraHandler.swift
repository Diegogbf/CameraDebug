//
//  CameraHandler.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/14/25.
//


import AVFoundation
import UIKit

final class CameraHandler: NSObject {
    let session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let photoOutput = AVCapturePhotoOutput()
    private var deviceInput: AVCaptureDeviceInput?
    var shouldNotifyVideoFrame = false
    var image: UIImage?
    private var cameraPosition: AVCaptureDevice.Position = .back

    func configure() {
        createInput(for: cameraPosition)

        photoOutput.maxPhotoQualityPrioritization = .quality
        session.sessionPreset = AVCaptureSession.Preset.photo

        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        }
            
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
            videoOutput.setSampleBufferDelegate(
                self,
                queue: .global(qos: .userInitiated)
            )
        }
        session.commitConfiguration()
        start()
    }

    func start() {
        Task.detached { [weak self] in
            self?.session.startRunning()
        }
    }

    func stop() {
        Task.detached { [weak self] in
            self?.session.stopRunning()
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
        Task.detached { [weak self, ] in
            self?.createInput(for: newPosition)
            self?.session.commitConfiguration()
        }
    }

    func capturePhoto() {
        Task.detached { [weak self] in
            guard let self else { return }
            let photoSettings = AVCapturePhotoSettings()
            if let previewPhotoPixelFormatType = photoSettings.availablePreviewPhotoPixelFormatTypes.first {
                photoSettings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPhotoPixelFormatType]
            }
            photoSettings.photoQualityPrioritization = .balanced

            if let photoOutputVideoConnection = photoOutput.connection(with: .video) {
                if photoOutputVideoConnection.isVideoRotationAngleSupported(rotationAngle) {
                    photoOutputVideoConnection.videoRotationAngle = rotationAngle
                }
            }
    
            self.photoOutput.capturePhoto(with: photoSettings, delegate: self)
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

extension CameraHandler: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = sampleBuffer.imageBuffer else { return }

        if connection.isVideoRotationAngleSupported(rotationAngle) {
            connection.videoRotationAngle = rotationAngle
        }
    
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            if shouldNotifyVideoFrame {
                image = UIImage(cgImage: cgImage)
            }
        }
    }
}

extension CameraHandler: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        self.image = image
        Task.detached { [weak self] in
            self?.session.stopRunning()
        }
    }
}
