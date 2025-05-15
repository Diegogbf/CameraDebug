//
//  ContentView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI

struct StillPhotoView: View {
    @ObservedObject var viewModel: StillPhotoViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CameraView(
                    sample: $viewModel.sample,
                    isRecording: $viewModel.isRecording,
                    session: viewModel.cameraHandler.session
                )
                {
                    viewModel.captureFrame()
                } flipButtonAction: {
                    Task {
                        await viewModel.flipCamera()
                    }
                }
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.8
                )
                HStack(alignment: .center) {
                    NavigationLink(value: viewModel.sample) {
                        Text("Continue")
                    }.disabled(viewModel.sample == nil)
                }
                .padding(.top)
            }.task {
                await viewModel.configure()
            }.alert(
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
            }.onDisappear {
                Task {
                    await viewModel.stop()
                }
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
    StillPhotoView(viewModel: StillPhotoViewModel())
}
