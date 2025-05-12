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
        VStack {
            ZStack(alignment: .bottom) {
                ZStack {
                    if let image = viewModel.image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                    } else {
                        CameraPreviewView(session: viewModel.session)
                    }
                }
                .background(Color.gray)
                .cornerRadius(10)
                .padding(35)
                TakePictureButton {
                    viewModel.capturePhoto()
                }
                .offset(y: -50)
                FlipCameraButton {
                    viewModel.flipCamera()
                }
                .offset(x: 120, y: -60)
            }
            HStack(alignment: .center) {
                if viewModel.image != nil {
                    Button("Retake Photo") {
                        viewModel.reset()
                    }
                    .buttonStyle(CustomButton())
                }
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
    StillPhotoView()
}
