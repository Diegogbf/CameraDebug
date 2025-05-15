//
//  ViewCaptureView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/12/25.
//

import SwiftUI
import AVFoundation

struct VideoCaptureView: View {
    @StateObject var viewModel = VideoCaptureViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                CameraView(
                    image: $viewModel.image,
                    isRecording: $viewModel.isRecording,
                    session: viewModel.cameraHandler.session
                ) {
                    viewModel.recordButtonTapped()
                } flipButtonAction: {
                    viewModel.flipCamera()
                }
                .frame(
                    width: geometry.size.width * 0.9,
                    height: geometry.size.height * 0.8
                )
                HStack(spacing: 20) {
                    Button(viewModel.isRecording ? "Capture" : "Reset") {
                        viewModel.captureFrame()
                    }
                    .buttonStyle(CustomButton())
                    .disabled(viewModel.image == nil && !viewModel.isRecording)
                    NavigationLink {
                        ResultsView(viewModel: viewModel)
                    } label: {
                        Text("Continue")
                            .disabled(viewModel.image == nil)
                    }
                }
                .padding(.top)
            }.onAppear {
                viewModel.configure()
            }
            .padding(
                .vertical, geometry.size.height * 0.05
            )
            .padding(
                .horizontal, geometry.size.width * 0.05
            )
        }
    }
}

struct CameraView: View {
    @Binding var image: UIImage?
    @Binding var isRecording: Bool
    let session: AVCaptureSession
    let mainButtonAction: () -> Void
    let flipButtonAction: () -> Void

    var body: some View {
        ZStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else {
                CameraPreviewView(session: session)
            }
        }
        .background(Color.gray)
        .cornerRadius(10)
        .overlay(alignment: .bottom) {
            HStack(spacing: 20) {
                Spacer()
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

#Preview {
    VideoCaptureView()
}
