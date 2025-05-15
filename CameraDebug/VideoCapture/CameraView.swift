//
//  CameraView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/15/25.
//

import AVFoundation
import SwiftUI

struct CameraView: View {
    @Binding var image: UIImage?
    @Binding var isRecording: Bool
    let session: AVCaptureSession
    let mainButtonAction: () -> Void
    let flipButtonAction: () -> Void

    var body: some View {
        ZStack {
            CameraPreviewView(session: session)
        }
        .background(Color.gray)
        .cornerRadius(10)
        .overlay(alignment: .bottom) {
            HStack(spacing: 40) {
                Spacer()
                ThumbnailView(image: image)
                TakePictureButton(
                    isRecording: isRecording,
                    action: mainButtonAction
                )
                FlipCameraButton(action: flipButtonAction)
                Spacer()
            }
            .padding(50)
        }
    }
}
