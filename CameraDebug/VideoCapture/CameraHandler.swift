//
//  CameraHandler.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/14/25.
//

import AVFoundation
import UIKit

final class CameraHandler: NSObject {
    let session = SessionCaptureHolder()
    private let videoOutput = AVCaptureVideoDataOutput()
    private let photoOutput = AVCapturePhotoOutput()
    private var deviceInput: AVCaptureDeviceInput?
    private var cameraPosition: AVCaptureDevice.Position = .back
    private var addToCameraStream: ((UIImage, AVCaptureDevice.Position) -> Void)?

    lazy var cameraStream: AsyncStream<(image: UIImage, position: AVCaptureDevice.Position)> = AsyncStream { continuation in
        addToCameraStream = { image, position in
            continuation.yield((image: image, position: position))
        }
    }

    private var frameCaptureCompletion: ((UIImage, AVCaptureDevice.Position) -> Void)?

    func configure() async throws {
        Task.detached { [weak self] in
            guard let self else { return }

            guard try await self.checkAuthorization() else { return }
            await self.createInput(for: cameraPosition)

            self.photoOutput.maxPhotoQualityPrioritization = .quality
            self.videoOutput.setSampleBufferDelegate(
                self,
                queue: .global(qos: .userInitiated)
            )

            for output in [self.photoOutput, self.videoOutput] {
                await self.session.addOutput(output)
            }

            await self.session.commitConfiguration()
            await self.start()
        }
    }

    func start() async {
        await session.start()
    }

    func stop() async {
        await session.stop()
    }

    func createInput(for position: AVCaptureDevice.Position) async {
        await session.beginConfiguration()
        if let deviceInput {
            await session.removeInput(deviceInput)
        }
        
        if let device = AVCaptureDevice.default(
            .builtInWideAngleCamera,
            for: .video,
            position: position
        ),
        let input = try? AVCaptureDeviceInput(device: device) {
            await session.addInput(input)
            deviceInput = input
        }
    }
    
    func flipCamera() async {
        let newPosition: AVCaptureDevice.Position = cameraPosition == .back ? .front : .back
        cameraPosition = newPosition
        Task.detached { [weak self] in
            guard let self else { return }

            await self.createInput(for: newPosition)
            await self.session.commitConfiguration()
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

    func captureFrame() async throws -> (image: UIImage, position: AVCaptureDevice.Position) {
        return await withCheckedContinuation { continuation in
            frameCaptureCompletion = { [weak self] image, position in
                self?.frameCaptureCompletion = nil
                continuation.resume(returning: (image: image, position: position))
            }
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
    
    enum CameraError: Error {
        case accessDenied
    }

    private func checkAuthorization() async throws -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return true
        case .notDetermined:
            let status = await AVCaptureDevice.requestAccess(for: .video)
            return status
        case .denied:
            throw CameraError.accessDenied
        default:
            return false
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
            frameCaptureCompletion?(UIImage(cgImage: cgImage), cameraPosition)
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
        addToCameraStream?(image, cameraPosition)
    }
}
