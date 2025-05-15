//
//  ResultsView.swift
//  CameraDebug
//
//  Created by Diego Gomes Basilio Fernandes on 5/13/25.
//

import SwiftUI

struct ResultsView: View {
    @State private var currentZoom = 0.0
    @State private var lastPosition = 1.0
    @ObservedObject var viewModel: VideoCaptureViewModel
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 24) {
                if let image = viewModel.stillImage {
                    ResultImageView(image: image)
                }
                
                if let image = viewModel.image {
                    ResultImageView(image: image)
                }
            }
            .scaleEffect(currentZoom + lastPosition)
            .gesture(
                MagnifyGesture()
                    .onChanged { value in
                        currentZoom = value.magnification - 1
                    }
                    .onEnded { value in
                        lastPosition += currentZoom
                        currentZoom = 0
                    }
            )
            .frame(height: geometry.size.height * 0.7)
            .padding(
                .vertical, geometry.size.width * 0.2
            )
            .padding(
                .horizontal, 20
            )
        }
    }
}

struct ResultImageView: View {
    let image: UIImage
    
    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .cornerRadius(10)
    }
}

#Preview {
    ResultsView(
        viewModel: VideoCaptureViewModel(
            stillImage: UIImage(
                systemName: "star"
            ),
            videoFrame: UIImage(systemName: "pencil")
        )
    )
}
