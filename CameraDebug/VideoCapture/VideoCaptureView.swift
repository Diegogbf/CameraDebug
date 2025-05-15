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
                    width: geometry.size.width * 0.8,
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
                    }.disabled(viewModel.image == nil)
                }
                .padding(.top)
            }.onAppear {
                viewModel.configure()
            }
            .onDisappear {
                viewModel.stop()
            }
            .padding(
                .horizontal, geometry.size.width * 0.1
            )
            .padding(
                .vertical, geometry.size.height * 0.05
            )
        }
    }
}

#Preview {
    VideoCaptureView()
}
