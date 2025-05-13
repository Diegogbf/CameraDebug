//
//  ViewCaptureView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/12/25.
//

import SwiftUI

struct ViewCaptureView: View {
    @StateObject var viewModel = VideoCaptureViewModel()

    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        CameraPreviewView(session: viewModel.session)
                    }
                }
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.8
                )
                .background(Color.gray)
                .cornerRadius(10)
                .overlay(alignment: .bottom) {
                    HStack(spacing: 20) {
                        Spacer()
                        TakePictureButton(isRecording: viewModel.isRecording) {
                            viewModel.recordButtonTapped()
                        }
                        FlipCameraButton {
                            viewModel.flipCamera()
                        }
                        Spacer()
                    }
                    .padding(50)
                }
                HStack(spacing: 20) {
                    Button(viewModel.isRecording ? "Capture" : "Reset") {
                        viewModel.captureFrame()
                    }
                    .buttonStyle(CustomButton())
                    .disabled(viewModel.image == nil && !viewModel.isRecording)
                    Button("Continue") {
                        
                    }
                    .buttonStyle(CustomButton())
                    .disabled(viewModel.image == nil)
                }
                .padding(.top)
            }.onAppear {
                viewModel.configure()
            }
            .padding(
                .vertical, geometry.size.height * 0.05
            )
            .padding(
                .horizontal, geometry.size.width * 0.1
            )
        }
    }
}

#Preview {
    ViewCaptureView()
}
