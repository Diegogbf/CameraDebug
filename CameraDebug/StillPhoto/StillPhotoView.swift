//
//  ContentView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/11/25.
//

import SwiftUI

struct StillPhotoView: View {
    @StateObject var viewModel = StillPhotoViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                CameraView(
                    image: $viewModel.image,
                    isRecording: $viewModel.isRecording,
                    session: viewModel.cameraHandler.session
                )
                {
                    viewModel.captureFrame()
                } flipButtonAction: {
                    viewModel.flipCamera()
                }
                .frame(
                    width: geometry.size.width * 0.8,
                    height: geometry.size.height * 0.8
                )
                HStack(alignment: .center) {
                    NavigationLink {
                        VideoCaptureView()
                    } label: {
                        Text("Continue")
                    }.disabled(viewModel.image == nil)
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
                viewModel.stop()
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
    StillPhotoView()
}
