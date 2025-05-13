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
        VStack {
            ZStack(alignment: .bottom) {
                ZStack {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        CameraPreviewView(session: viewModel.session)
                    }
                }
                .background(Color.gray)
                .cornerRadius(10)
                .padding(35)
                TakePictureButton(isRecording: viewModel.isRecording) {
                    viewModel.recordButtonTapped()
                }
                .offset(y: -50)
                FlipCameraButton {
                    viewModel.flipCamera()
                }
                .offset(x: 120, y: -60)
            }
            HStack(alignment: .center) {
                Button("Capture Frame") {
                    viewModel.captureFrame()
                }
                .buttonStyle(CustomButton())
                .disabled(!viewModel.isRecording)
                Button("Continue") {
                    
                }
                .buttonStyle(CustomButton())
                .disabled(viewModel.image == nil)
            }
        }.onAppear {
            viewModel.configure()
        }
    }
}

#Preview {
    ViewCaptureView()
}
