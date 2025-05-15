//
//  SessionCaptureHolder.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/15/25.
//

import AVFoundation

actor SessionCaptureHolder {
    let session = AVCaptureSession()

    init() {
        session.sessionPreset = AVCaptureSession.Preset.photo
    }

    func start() {
        guard !session.isRunning else { return }
        Task.detached { [weak self] in
            await self?.session.startRunning()
        }
    }

    func stop() {
        guard session.isRunning else { return }
        Task.detached { [weak self] in
            await self?.session.stopRunning()
        }
    }

    func commitConfiguration() {
        Task.detached { [weak self] in
            await self?.session.commitConfiguration()
        }
    }

    func beginConfiguration() {
        Task.detached { [weak self] in
            await self?.session.beginConfiguration()
        }
    }

    // I know that this is leading to a warning and i think this is a very specific issue due to the fact that the preview of the camera must be configured using UIViewRepresenatable in a non async context. I didnt find any resource that helped me creating this solution avoiding the error and that is typically a situation where i would try to set up a technical discussion to the better aproach. Also, maybe in the future we'll have a native away by apple to handle this setup async
    nonisolated func setupPreview(_ layer: AVCaptureVideoPreviewLayer) {
        layer.session = session
    }

    func addInput(_ input: AVCaptureInput) {
        guard session.canAddInput(input) else { return }
        session.addInput(input)
    }

    func removeInput(_ input: AVCaptureInput) {
        guard session.inputs.contains(input) else { return }
        session.removeInput(input)
    }

    func addOutput(_ output: AVCaptureOutput) {
        guard session.canAddOutput(output) else { return }
        session.addOutput(output)
    }
}
