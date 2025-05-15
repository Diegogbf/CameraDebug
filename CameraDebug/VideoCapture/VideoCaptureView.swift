//
//  ViewCaptureView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/12/25.
//

import SwiftUI
import AVFoundation

struct VideoCaptureView: View {
    @ObservedObject var viewModel: VideoCaptureViewModel

    var body: some View {
        GeometryReader { geometry in
            VStack {
                CameraView(
                    sample: $viewModel.sample,
                    isRecording: $viewModel.isRecording,
                    session: viewModel.cameraHandler.session
                ) {
                    viewModel.recordButtonTapped()
                } flipButtonAction: {
                    Task {
                        await viewModel.flipCamera()
                    }
                }
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.8
                )
                HStack(spacing: 20) {
                    Button("Capture") {
                        viewModel.captureFrame()
                    }
                    .buttonStyle(CustomButton())
                    .disabled(viewModel.sample == nil && !viewModel.isRecording)
                    NavigationLink(value: viewModel.sample) {
                        Text("Continue")
                    }.disabled(viewModel.sample == nil)
                }
                .padding(.top)
            }.task {
                await viewModel.configure()
            }
            .onDisappear {
                Task {
                    await viewModel.stop()
                }
            }
            .alert(
                isPresented: $viewModel.displayError,
                error: viewModel.contextError
            ) { error in
                Button("Ok") {
                    switch error {
                    case .cameraDenied:
                        guard let url = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        UIApplication.shared.open(url)
                    case .unexpected:
                        break
                    }
                }
            } message: { error in
                Text(error.message)
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
    VideoCaptureView(viewModel: VideoCaptureViewModel())
}
